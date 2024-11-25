part of 'generate_key_bloc.dart';

sealed class GenerateKeyEvent {}

@blocEvent
class ResetGenerateKey extends GenerateKeyEvent with _$ResetGenerateKey {
  const factory ResetGenerateKey() = _ResetGenerateKey;
}

@blocEvent
class NextStep extends GenerateKeyEvent with _$NextStep {
  const factory NextStep() = _NextStep;
}

@blocEvent
class PreviousStep extends GenerateKeyEvent with _$PreviousStep {
  const factory PreviousStep() = _PreviousStep;
}

@blocEvent
class GenerateRSAKeyPair extends GenerateKeyEvent with _$GenerateRSAKeyPair {
  const factory GenerateRSAKeyPair() = _GenerateRSAKeyPair;
}

@blocEvent
class GenerateAESSymmetricKey extends GenerateKeyEvent
    with _$GenerateAESSymmetricKey {
  const factory GenerateAESSymmetricKey() = _GenerateAESSymmetricKey;
}

@blocEvent
class SelectTeacherPublicKeyFile extends GenerateKeyEvent
    with _$SelectTeacherPublicKeyFile {
  const factory SelectTeacherPublicKeyFile() = _SelectTeacherPublicKeyFile;
}

@blocEvent
class SelectFileToSend extends GenerateKeyEvent with _$SelectFileToSend {
  const factory SelectFileToSend() = _SelectFileToSend;
}

class ClearSelectedFile extends GenerateKeyEvent {
  ClearSelectedFile();
}

@blocEvent
class SignAndEncryptFile extends GenerateKeyEvent with _$SignAndEncryptFile {
  const factory SignAndEncryptFile() = _SignAndEncryptFile;
}

@blocEvent
class ProtectAES extends GenerateKeyEvent with _$ProtectAES {
  const factory ProtectAES() = _ProtectAES;
}

@blocEvent
class SendPackage extends GenerateKeyEvent with _$SendPackage {
  const factory SendPackage() = _SendPackage;
}

@blocEvent
class SelectTeacherPrivateKeyFile extends GenerateKeyEvent
    with _$SelectTeacherPrivateKeyFile {
  const factory SelectTeacherPrivateKeyFile() = _SelectTeacherPrivateKeyFile;
}

@blocEvent
class CheckPackage extends GenerateKeyEvent with _$CheckPackage {
  const factory CheckPackage() = _CheckPackage;
}

class RestartProcess extends GenerateKeyEvent {
  RestartProcess();
}
