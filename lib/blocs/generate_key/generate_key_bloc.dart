import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/core/annotations.dart';
import 'package:hash_link/helpers/aes_key_helper.dart';
import 'package:hash_link/helpers/rsa_key_helper.dart';

part 'generate_key_event.dart';
part 'generate_key_state.dart';

part 'generate_key_bloc.freezed.dart';

class GenerateKeyBloc extends Bloc<GenerateKeyEvent, GenerateKeyState> {
  final _states = <GenerateKeyState>[];

  GenerateKeyBloc() : super(const KeyGeneration()) {
    on<NextStep>((event, emit) {
      _states.add(state);

      if (state is KeyGeneration) {
        emit(const Preparation());
        return;
      } else if (state is Preparation) {
        emit(const Signature());
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
          emit(state.copyWith(symmetricKey: aesKey));
        }
      }
    });
  }
}
