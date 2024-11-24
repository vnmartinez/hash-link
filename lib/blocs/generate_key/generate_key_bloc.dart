import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/core/annotations.dart';
import 'package:hash_link/helpers/aes_key_helper.dart';
import 'package:hash_link/helpers/file_reader_helper.dart';
import 'package:hash_link/helpers/rsa_key_helper.dart';
import 'package:hash_link/helpers/secure_file_helper.dart';

part 'generate_key_event.dart';
part 'generate_key_state.dart';

part 'generate_key_bloc.freezed.dart';

class GenerateKeyBloc extends Bloc<GenerateKeyEvent, GenerateKeyState> {
  final FilePicker _filePicker;

  final _states = <GenerateKeyState>[];

  GenerateKeyBloc({required FilePicker filePicker})
      : _filePicker = filePicker,
        super(const KeyGeneration()) {
    on<NextStep>((event, emit) {
      final state = this.state;
      _states.add(state);

      if (state is KeyGeneration && state.isValid) {
        emit(Preparation(
          publicKey: state.publicKey!,
          privateKey: state.privateKey!,
          symmetricKey: state.symmetricKey!,
        ));
        return;
      } else if (state is Preparation && state.isValid) {
        emit(Signature(
          publicKey: state.publicKey,
          privateKey: state.privateKey,
          symmetricKey: state.symmetricKey,
          fileToSend: state.fileToSend!,
          teacherPublicKeyFile: state.teacherPublicKeyFile!,
        ));
        return;
      } else if (state is Signature) {
        emit(const Protection());
        return;
      } else if (state is Protection) {
        emit(const Shipping());
        return;
      } else if (state is Shipping) {
        emit(const Decryption());
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

    on<GenerateRSAKeyPair>((event, emit) {
      final rsaKeys = RSAKeyHelper.generateRSAKeyPair();
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
          emit(state.copyWith(symmetricKey: AESKeyHelper.keyToBase64(aesKey)));
        }
      }
    });

    on<SelectTeacherPublicKeyFile>((event, emit) async {
      var state = this.state;
      if (state is Preparation) {
        state = state.copyWith(selectingTeacherPublicKeyFile: true);
        emit(state);

        final pickeFiles = await _filePicker.pickFiles(allowCompression: false);
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
        final pickeFiles = await _filePicker.pickFiles(allowCompression: false);
        state = state.copyWith(selectingFileToSend: false);
        emit(state);
        if (pickeFiles == null) return;

        final file = FileReader.fromPlatformFile(pickeFiles.files.single);
        emit(state.copyWith(fileToSend: file));
      }
    });

    on<Signin>((event, emit) {
      var state = this.state;
      if (state is Signature) {
        final privateKey =
            RSAKeyHelper.parsePrivateKeyFromPem(state.privateKey);
        final signature = SecureFileHelper.signFile(
            Uint8List.fromList(state.fileToSend.bytes), privateKey);
        print(signature);
      }
    });
  }
}
