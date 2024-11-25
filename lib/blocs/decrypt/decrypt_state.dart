part of 'decrypt_bloc.dart';

@blocState
class DecryptState with _$DecryptState {
  const factory DecryptState({
    Uint8List? dataEncrypted,
    String? dataEncryptedError,
    Uint8List? aesKey,
    String? aesKeyError,
    Uint8List? signature,
    String? signatureError,
    Uint8List? publicKey,
    String? publicKeyError,
    Uint8List? privateKey,
    String? privateKeyError,
    Uint8List? decryptedFile,
    String? decryptionError,
    @Default(false) bool selectingPackage,
    @Default(false) bool selectingPrivateKey,
    @Default(false) bool isSignatureValid,
  }) = _DecryptState;
}

extension DecryptStateExtension on DecryptState {
  bool get inputsIsValid =>
      dataEncrypted != null &&
      dataEncryptedError == null &&
      aesKey != null &&
      aesKeyError == null &&
      signature != null &&
      signatureError == null &&
      publicKey != null &&
      publicKeyError == null &&
      privateKey != null &&
      privateKeyError == null;
}
