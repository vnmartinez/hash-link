import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/core/annotations.dart';
import 'package:hash_link/helpers/aes_key_helper.dart';
import 'package:hash_link/helpers/digest_helper.dart';
import 'package:hash_link/helpers/file_reader_helper.dart';
import 'package:hash_link/helpers/rsa_key_helper.dart';
import 'package:hash_link/helpers/zip_helper.dart';

part 'generate_key_event.dart';
part 'generate_key_state.dart';
part 'generate_key_bloc.freezed.dart';

class GenerateKeyBloc extends Bloc<GenerateKeyEvent, GenerateKeyState> {
  final FilePicker _filePicker;
  final ZipHelper _zipHelper;

  final _states = <GenerateKeyState>[];

  GenerateKeyBloc(
      {required FilePicker filePicker, required ZipHelper zipHelper})
      : _filePicker = filePicker,
        _zipHelper = zipHelper,
        super(const KeyGeneration()) {
    on<ResetGenerateKey>((event, emit) {
      emit(const KeyGeneration());
      _states.clear();
    });

    on<NextStep>((event, emit) {
      final state = this.state;
      _states.add(state);

      if (state is KeyGeneration && state.isValid) {
        emit(Preparation.fromValidKeyGeneration(state));
        return;
      } else if (state is Preparation && state.isValid) {
        emit(Signature.fromValidPreparation(state));
        return;
      } else if (state is Signature && state.isValid) {
        emit(Protection.fromValidSignature(state));
        return;
      } else if (state is Protection && state.isValid) {
        emit(Shipping.fromValidProtection(state));
        return;
      } else if (state is Shipping) {
        emit(Decryption.fromValidShipping(state));
        return;
      } else if (state is Decryption) {
        // Do nothing cause is the last step.
      }
      _states.removeLast();
    });

    on<PreviousStep>((event, emit) {
      if (_states.isEmpty) return;
      emit(_states.removeLast());
    });

    on<GenerateRSAKeyPair>((event, emit) async {
      final rsaKeys = await RSAKeyHelper.generateRSAKeyPair();

      emit(KeyGeneration(
          publicKey: rsaKeys.publicKey, privateKey: rsaKeys.privateKey));
    });

    on<GenerateAESSymmetricKey>((event, emit) {
      final state = this.state;
      if (state is KeyGeneration) {
        final publicKey = state.privateKey;
        final privateKey = state.privateKey;

        if (publicKey != null && privateKey != null) {
          final aesKey = AESKeyHelper.generateAESKey();
          emit(state.copyWith(symmetricKey: base64.encode(aesKey)));
        }
      }
    });

    on<SelectTeacherPublicKeyFile>((event, emit) async {
      var state = this.state;
      if (state is Preparation) {
        state = state.copyWith(selectingTeacherPublicKeyFile: true);
        emit(state);

        final pickeFiles = await _filePicker.pickFiles(
            allowCompression: false, withData: true);
        state = state.copyWith(selectingTeacherPublicKeyFile: false);
        emit(state);
        if (pickeFiles == null) return;

        final file = FileReader.fromPlatformFile(pickeFiles.files.single);
        emit(state.copyWith(teacherPublicKeyFile: file));
      }
    });

    on<SelectFileToSend>((event, emit) async {
      var state = this.state;
      if (state is Preparation) {
        state = state.copyWith(selectingFileToSend: true);
        emit(state);
        final pickeFiles = await _filePicker.pickFiles(
            allowCompression: false, withData: true);
        state = state.copyWith(selectingFileToSend: false);
        emit(state);
        if (pickeFiles == null) return;

        final file = FileReader.fromPlatformFile(pickeFiles.files.single);
        emit(state.copyWith(fileToSend: file));
      }
    });

    on<SignAndEncryptFile>((event, emit) {
      final state = this.state;
      if (state is Signature) {
        final fileBytes = Uint8List.fromList(state.fileToSend.bytes);

        final privateKey =
            RSAKeyHelper.parsePrivateKeyFromPem(state.privateKey);
        final fileDigest = DigestHelper.create(fileBytes);
        final fileSignature =
            RSAKeyHelper.signWithPrivateKey(fileDigest, privateKey);
        final signatureEncryption = AESKeyHelper.encryptWithAES(
            fileBytes, base64.decode(state.symmetricKey));

        emit(state.copyWith(
          fileDigest: base64.encode(fileDigest),
          fileSignature: base64.encode(fileSignature),
          fileEncryption: base64.encode(signatureEncryption),
        ));
      }
    });

    on<ProtectAES>((event, emit) {
      final state = this.state;
      if (state is Protection) {
        final aes = base64.decode(state.symmetricKey);
        final externalPublicKeyPem =
            utf8.decode(state.teacherPublicKeyFile.bytes);
        final externalPublicKey =
            RSAKeyHelper.parsePublicKeyFromPem(externalPublicKeyPem);
        final aesEncryption =
            RSAKeyHelper.encryptDataWithPublicKey(aes, externalPublicKey);

        emit(state.copyWith(
          symmetricKeyEncryption: base64.encode(aesEncryption),
        ));
      }
    });

    on<SendPackage>((event, emit) async {
      final state = this.state;
      if (state is Shipping) {
        final fileEncripted = base64.decode(state.fileEncryption);
        final signature = base64.decode(state.fileSignature);
        final symmetricKey = base64.decode(state.symmetricKeyEncryption);
        final publicKey = utf8.encode(state.publicKey);

        await _zipHelper.zipAndSaveLocal('package', [
          ZipData(name: 'data_encrypted.aes', bytes: fileEncripted),
          ZipData(name: 'aes_key.rsa', bytes: symmetricKey),
          ZipData(name: 'signature.sig', bytes: signature),
          ZipData(name: 'public_key.pem', bytes: publicKey),
        ]);

        emit(state.copyWith(packageSended: true));
      }
    });

    on<SelectTeacherPrivateKeyFile>((event, emit) async {
      var state = this.state;
      if (state is Decryption) {
        state = state.copyWith(selectingTeacherPrivateKeyFile: true);
        emit(state);
        final pickeFiles = await _filePicker.pickFiles(
            allowCompression: false, withData: true);
        state = state.copyWith(selectingTeacherPrivateKeyFile: false);
        emit(state);
        if (pickeFiles == null) return;

        final file = FileReader.fromPlatformFile(pickeFiles.files.single);
        emit(state.copyWith(teacherPrivateKeyFile: file));
      }
    });

    on<CheckPackage>((event, emit) {
      final state = this.state;
      if (state is Decryption && state.teacherPrivateKeyFile != null) {
        final encryptedKey = base64.decode(state.symmetricKeyEncryption);
        final privateKey = RSAKeyHelper.parsePrivateKeyFromPem(utf8
            .decode(Uint8List.fromList(state.teacherPrivateKeyFile!.bytes)));
        final decryptedKey =
            RSAKeyHelper.decryptDataWithPrivateKey(encryptedKey, privateKey);

        if (base64.encode(decryptedKey) != state.symmetricKey) {
          emit(state.copyWith(validDecryption: false));
          return;
        }

        final fileSignature = RSAKeyHelper.parseSignatureFromBytes(
            base64.decode(state.fileSignature));

        final fileEncryption = base64.decode(state.fileEncryption);

        final fileBytes =
            AESKeyHelper.decryptWithAES(fileEncryption, decryptedKey);

        final fileDigest = DigestHelper.create(fileBytes);
        final publicKey = RSAKeyHelper.parsePublicKeyFromPem(state.publicKey);

        final isValidSignature = RSAKeyHelper.verifySignatureWithPublicKey(
            fileSignature, fileDigest, publicKey);

        emit(state.copyWith(
          validDecryption: isValidSignature,
          decryptedContent: base64.encode(fileBytes),
          decryptedFileName: state.fileToSend.name,
        ));
      }
    });

    on<RestartProcess>((event, emit) {
      emit(const KeyGeneration());
    });
  }
}
