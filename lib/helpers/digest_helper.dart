import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

class DigestHelper {
  static Uint8List create(Uint8List data) {
    return Uint8List.fromList(crypto.sha256.convert(data).bytes);
  }
}
