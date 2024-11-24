import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

class AESKeyHelper {
  static Uint8List generateAESKey() {
    final secureRandom = pc.FortunaRandom();

    final seedSource = Uint8List.fromList(
        List.generate(32, (_) => DateTime.now().microsecond % 256));
    secureRandom.seed(pc.KeyParameter(seedSource));

    return secureRandom.nextBytes(32);
  }

  static String keyToBase64(Uint8List key) {
    return base64.encode(key);
  }

  static Uint8List base64ToKey(String base64Key) {
    return Uint8List.fromList(base64.decode(base64Key));
  }

  static Uint8List encryptWithAES(Uint8List data, Uint8List aesKey) {
    final iv = Uint8List(16);
    final secureRandom = pc.FortunaRandom();
    secureRandom.seed(
        pc.KeyParameter(Uint8List.fromList(List.generate(32, (i) => i + 1))));
    secureRandom.nextBytes(iv.length);

    final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7')
      ..init(true, pc.ParametersWithIV(pc.KeyParameter(aesKey), iv));

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
