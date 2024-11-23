import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/core/annotations.dart';
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
      } else if (state is Preparation) {
        emit(const Signature());
      } else if (state is Signature) {
        emit(const Protection());
      } else if (state is Protection) {
        emit(const Shipping());
      } else if (state is Shipping) {
        emit(const Decryption());
      } else if (state is Decryption) {
        // Do nothing cause is the last step.
      } else {
        _states.removeLast();
        throw UnimplementedError();
      }
    });

    on<PreviousStep>((event, emit) {
      if (_states.isEmpty) return;
      emit(_states.removeLast());
    });

    on<GenerateRSAKeyPair>((event, emit) {
      print(RSAKeyHelper.generateRSAKeyPair().publicKey);
    });

    on<GenerateAESSymmetricKey>((event, emit) {
      // TODO (Gabriel Pagotto): Implement this event
    });
  }
}
