import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

class AESKeyHelper {
  static Uint8List generateAESKey() {
    final secureRandom = pc.FortunaRandom();

    final seedSource = Uint8List.fromList(
      List.generate(32, (_) => DateTime.now().microsecond % 256),
    );
    secureRandom.seed(pc.KeyParameter(seedSource));

    return secureRandom.nextBytes(32);
  }

  static Uint8List encryptWithAES(Uint8List data, Uint8List aesKey) {
    final iv = Uint8List(16);

    pc.FortunaRandom()
      ..seed(
          pc.KeyParameter(Uint8List.fromList(List.generate(32, (i) => i + 1))))
      ..nextBytes(16);

    final parameters = pc.ParametersWithIV(pc.KeyParameter(aesKey), iv);
    final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7')
      ..init(true, pc.PaddedBlockCipherParameters(parameters, null));

    final encryptedData = cipher.process(data);

    return Uint8List.fromList(iv + encryptedData);
  }

  static Uint8List decryptWithAES(Uint8List encryptedData, Uint8List aesKey) {
    final iv = encryptedData.sublist(0, 16);
    final ciphertext = encryptedData.sublist(16);

    final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7')
      ..init(false, pc.ParametersWithIV(pc.KeyParameter(aesKey), iv));

    return cipher.process(ciphertext);
  }
}
