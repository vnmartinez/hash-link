part of 'generate_key_bloc.dart';

sealed class GenerateKeyState {}

@blocState
class KeyGeneration extends GenerateKeyState with _$KeyGeneration {
  const factory KeyGeneration({
    String? publicKey,
    String? privateKey,
    String? symmetricKey,
  }) = _KeyGeneration;
}

@blocState
class Preparation extends GenerateKeyState with _$Preparation {
  const factory Preparation({
    required String publicKey,
    required String privateKey,
    required String symmetricKey,
    FileReader? teacherPublicKeyFile,
    @Default(false) bool selectingTeacherPublicKeyFile,
    FileReader? fileToSend,
    @Default(false) bool selectingFileToSend,
  }) = _Preparation;
}

@blocState
class Signature extends GenerateKeyState with _$Signature {
  const factory Signature({
    required String publicKey,
    required String privateKey,
    required String symmetricKey,
    required FileReader fileToSend,
    required FileReader teacherPublicKeyFile,
    String? fileDigest,
    String? fileSignature,
    String? fileEncryption,
  }) = _Signature;
}

@blocState
class Protection extends GenerateKeyState with _$Protection {
  const factory Protection({
    required String publicKey,
    required String privateKey,
    required String symmetricKey,
    required FileReader fileToSend,
    required FileReader teacherPublicKeyFile,
    required String fileDigest,
    required String fileSignature,
    required String fileEncryption,
    String? symmetricKeyEncryption,
  }) = _Protection;
}

@blocState
class Shipping extends GenerateKeyState with _$Shipping {
  const factory Shipping() = _Shipping;
}

@blocState
class Decryption extends GenerateKeyState with _$Decryption {
  const factory Decryption() = _Decryption;
}

extension KeyGenerationExtension on KeyGeneration {
  bool get isValid =>
      publicKey != null && privateKey != null && symmetricKey != null;
  bool get canGenerateSymmetricKey => publicKey != null && privateKey != null;
}

extension PreparationExtension on Preparation {
  bool get isValid => teacherPublicKeyFile != null && fileToSend != null;
}

extension SignatureExtension on Signature {
  bool get isValid =>
      fileDigest != null && fileSignature != null && fileEncryption != null;
}

extension ProtectionExtension on Protection {
  bool get isValid => symmetricKeyEncryption != null;
}
