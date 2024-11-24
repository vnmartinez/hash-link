import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/export.dart' as pc;

class SecureFileHelper {
  static Uint8List signFile(Uint8List data, pc.RSAPrivateKey privateKey) {
    final sha256Digest = crypto.sha256.convert(data);
    final signer = pc.Signer('SHA-256/RSA')
      ..init(true, pc.PrivateKeyParameter<pc.RSAPrivateKey>(privateKey));

    final signature =
        signer.generateSignature(Uint8List.fromList(sha256Digest.bytes))
            as pc.RSASignature;
    return signature.bytes;
  }

  static String signatureToBase64(Uint8List signature) {
    return base64.encode(signature);
  }

  static Uint8List base64ToSignature(String base64Key) {
    return Uint8List.fromList(base64.decode(base64Key));
  }
}
