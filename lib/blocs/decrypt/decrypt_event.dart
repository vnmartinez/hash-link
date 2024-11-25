part of 'decrypt_bloc.dart';

sealed class DecryptEvent {}

@blocEvent
class ResetDecrypt extends DecryptEvent with _$ResetDecrypt {
  const factory ResetDecrypt() = _ResetDecrypt;
}

@blocEvent
class SelectPackage extends DecryptEvent with _$SelectPackage {
  const factory SelectPackage() = _SelectPackage;
}

@blocEvent
class SelectPrivateKey extends DecryptEvent with _$SelectPrivateKey {
  const factory SelectPrivateKey() = _SelectPrivateKey;
}

@blocEvent
class DecryptData extends DecryptEvent with _$DecryptData {
  const factory DecryptData() = _DecryptData;
}
