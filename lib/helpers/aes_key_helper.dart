import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

class AESKeyHelper {
  Uint8List generateAESKey() {
    final secureRandom = pc.FortunaRandom();

    final seedSource = Uint8List.fromList(
        List.generate(32, (_) => DateTime.now().microsecond % 256));
    secureRandom.seed(pc.KeyParameter(seedSource));

    return secureRandom.nextBytes(32);
  }

  String keyToBase64(Uint8List key) {
    return base64.encode(key);
  }

  Uint8List base64ToKey(String base64Key) {
    return Uint8List.fromList(base64.decode(base64Key));
  }
}
