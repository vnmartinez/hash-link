part of 'generate_key_bloc.dart';

sealed class GenerateKeyState {}

@blocState
class KeyGeneration extends GenerateKeyState with _$KeyGeneration {
  const factory KeyGeneration() = _KeyGeneration;
}

@blocState
class Preparation extends GenerateKeyState with _$Preparation {
  const factory Preparation() = _Preparation;
}

@blocState
class Signature extends GenerateKeyState with _$Signature {
  const factory Signature() = _Signature;
}

@blocState
class Protection extends GenerateKeyState with _$Protection {
  const factory Protection() = _Protection;
}

@blocState
class Shipping extends GenerateKeyState with _$Shipping {
  const factory Shipping() = _Shipping;
}

@blocState
class Decryption extends GenerateKeyState with _$Decryption {
  const factory Decryption() = _Decryption;
}
