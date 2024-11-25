import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/core/annotations.dart';
import 'package:hash_link/helpers/aes_key_helper.dart';
import 'package:hash_link/helpers/digest_helper.dart';
import 'package:hash_link/helpers/file_reader_helper.dart';
import 'package:hash_link/helpers/rsa_key_helper.dart';
import 'package:hash_link/helpers/zip_helper.dart';

part 'decrypt_event.dart';
part 'decrypt_state.dart';
part 'decrypt_bloc.freezed.dart';

class DecryptBloc extends Bloc<DecryptEvent, DecryptState> {
  final FilePicker _filePicker;
  final ZipHelper _zipHelper;

  DecryptBloc({required FilePicker filePicker, required ZipHelper zipHelper})
      : _filePicker = filePicker,
        _zipHelper = zipHelper,
        super(const DecryptState()) {
    on<ResetDecrypt>((event, emit) {
      emit(const DecryptState());
    });

    on<SelectPackage>((event, emit) async {
      emit(state.copyWith(selectingPackage: true));
      final result = await _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );
      if (result == null) {
        emit(state.copyWith(selectingPackage: false));
        return;
      }
      final file = result.files.single;

      try {
        final zipFile = FileReader.fromPlatformFile(file);
        final files = await _zipHelper.unzip(zipFile);

        Uint8List? dataEncrypted;
        Uint8List? aesKey;
        Uint8List? signature;
        Uint8List? publicKey;
        String? dataEncryptedError;
        String? aesKeyError;
        String? signatureError;
        String? publicKeyError;

        for (final file in files) {
          switch (file.name) {
            case 'data_encrypted.aes':
              dataEncrypted = file.bytes;
              break;
            case 'aes_key.rsa':
              aesKey = file.bytes;
              break;
            case 'signature.sig':
              signature = file.bytes;
              break;
            case 'public_key.pem':
              publicKey = file.bytes;
              break;
            default:
              break;
          }
        }

        if (dataEncrypted == null) {
          dataEncryptedError = 'data_encrypted.aes não encontrado';
        }
        if (aesKey == null) {
          aesKeyError = 'aes_key.rsa não encontrado';
        }
        if (signature == null) {
          signatureError = 'signature.sig não encontrado';
        }
        if (publicKey == null) {
          publicKeyError = 'public_key.pem não encontrado';
        }

        emit(DecryptState(
          dataEncrypted: dataEncrypted,
          dataEncryptedError: dataEncryptedError,
          aesKey: aesKey,
          aesKeyError: aesKeyError,
          signature: signature,
          signatureError: signatureError,
          publicKey: publicKey,
          publicKeyError: publicKeyError,
          privateKey: state.privateKey,
          privateKeyError: state.privateKeyError,
        ));
      } catch (e) {
        emit(state.copyWith(
          selectingPackage: false,
          dataEncryptedError: 'Erro ao descompactar o arquivo: $e',
        ));
      }
    });

    on<SelectPrivateKey>((event, emit) async {
      emit(state.copyWith(selectingPrivateKey: true));
      final result = await _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'pub', 'key', 'asc'],
        withData: true,
      );
      if (result == null) {
        emit(state.copyWith(selectingPrivateKey: false));
        return;
      }
      final file = result.files.single;

      final privateKey = utf8.decode(file.bytes ?? []);

      if (privateKey.isEmpty ||
          !privateKey.contains('-----BEGIN RSA PRIVATE KEY-----') ||
          !privateKey.contains('-----END RSA PRIVATE KEY-----')) {
        emit(state.copyWith(
          selectingPrivateKey: false,
          privateKeyError: 'Chave privada inválida',
        ));
        return;
      }

      emit(DecryptState(
        dataEncrypted: state.dataEncrypted,
        dataEncryptedError: state.dataEncryptedError,
        aesKey: state.aesKey,
        aesKeyError: state.aesKeyError,
        signature: state.signature,
        signatureError: state.signatureError,
        publicKey: state.publicKey,
        publicKeyError: state.publicKeyError,
        privateKey: file.bytes,
      ));
    });

    on<DecryptData>((event, emit) {
      if (!state.inputsIsValid) {
        return;
      }

      if (state.privateKey != null && state.dataEncrypted != null) {
        try {
          final privateKey = RSAKeyHelper.parsePrivateKeyFromPem(
              utf8.decode(state.privateKey!));
          final decryptedKey =
              RSAKeyHelper.decryptDataWithPrivateKey(state.aesKey!, privateKey);

          final fileSignature =
              RSAKeyHelper.parseSignatureFromBytes(state.signature!);
          final fileBytes =
              AESKeyHelper.decryptWithAES(state.dataEncrypted!, decryptedKey);
          final fileDigest = DigestHelper.create(fileBytes);
          final publicKey =
              RSAKeyHelper.parsePublicKeyFromPem(utf8.decode(state.publicKey!));

          final isValidSignature = RSAKeyHelper.verifySignatureWithPublicKey(
              fileSignature, fileDigest, publicKey);

          emit(state.copyWith(
            decryptedFile: fileBytes,
            isSignatureValid: isValidSignature,
            decryptionError: null,
          ));
        } catch (e) {
          emit(state.copyWith(
              decryptionError: 'Erro ao descriptografar o arquivo: $e'));
        }
      } else {
        emit(state.copyWith(
            decryptionError: 'Chave privada ou dados encriptados ausentes.'));
      }
    });
  }
}
