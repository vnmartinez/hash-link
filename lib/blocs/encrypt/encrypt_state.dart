part of 'encrypt_bloc.dart';

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

  factory Preparation.fromValidKeyGeneration(KeyGeneration state) {
    return Preparation(
      publicKey: state.publicKey!,
      privateKey: state.privateKey!,
      symmetricKey: state.symmetricKey!,
    );
  }
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

  factory Signature.fromValidPreparation(Preparation state) {
    return Signature(
      publicKey: state.publicKey,
      privateKey: state.privateKey,
      symmetricKey: state.symmetricKey,
      fileToSend: state.fileToSend!,
      teacherPublicKeyFile: state.teacherPublicKeyFile!,
    );
  }
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

  factory Protection.fromValidSignature(Signature state) {
    return Protection(
      publicKey: state.publicKey,
      privateKey: state.privateKey,
      symmetricKey: state.symmetricKey,
      fileToSend: state.fileToSend,
      teacherPublicKeyFile: state.teacherPublicKeyFile,
      fileDigest: state.fileDigest!,
      fileSignature: state.fileSignature!,
      fileEncryption: state.fileEncryption!,
    );
  }
}

@blocState
class Shipping extends GenerateKeyState with _$Shipping {
  const factory Shipping({
    required String publicKey,
    required String privateKey,
    required String symmetricKey,
    required FileReader fileToSend,
    required FileReader teacherPublicKeyFile,
    required String fileDigest,
    required String fileSignature,
    required String fileEncryption,
    required String symmetricKeyEncryption,
    @Default(false) bool packageSended,
  }) = _Shipping;

  factory Shipping.fromValidProtection(Protection state) {
    return Shipping(
      publicKey: state.publicKey,
      privateKey: state.privateKey,
      symmetricKey: state.symmetricKey,
      fileToSend: state.fileToSend,
      teacherPublicKeyFile: state.teacherPublicKeyFile,
      fileDigest: state.fileDigest,
      fileSignature: state.fileSignature,
      fileEncryption: state.fileEncryption,
      symmetricKeyEncryption: state.symmetricKeyEncryption!,
    );
  }
}

@blocState
class Decryption extends GenerateKeyState with _$Decryption {
  const factory Decryption({
    required String publicKey,
    required String privateKey,
    required String symmetricKey,
    required FileReader fileToSend,
    required FileReader teacherPublicKeyFile,
    required String fileDigest,
    required String fileSignature,
    required String fileEncryption,
    required String symmetricKeyEncryption,
    FileReader? teacherPrivateKeyFile,
    @Default(false) bool selectingTeacherPrivateKeyFile,
    @Default(false) bool validDecryption,
    String? decryptedContent,
    String? decryptedFileName,
  }) = _Decryption;

  factory Decryption.fromValidShipping(Shipping state) {
    return Decryption(
      publicKey: state.publicKey,
      privateKey: state.privateKey,
      symmetricKey: state.symmetricKey,
      fileToSend: state.fileToSend,
      teacherPublicKeyFile: state.teacherPublicKeyFile,
      fileDigest: state.fileDigest,
      fileSignature: state.fileSignature,
      fileEncryption: state.fileEncryption,
      symmetricKeyEncryption: state.symmetricKeyEncryption,
      decryptedContent: '',
    );
  }
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

extension ShippingExtension on Shipping {
  bool get isValid => packageSended;
}

extension DecryptionExtension on Decryption {
  bool get isValid => validDecryption && decryptedContent != null;
}
