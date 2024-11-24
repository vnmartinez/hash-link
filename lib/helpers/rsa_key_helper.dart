import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

import 'package:pointycastle/asn1/asn1_parser.dart' as asn1_parser;
import 'package:pointycastle/asn1/primitives/asn1_integer.dart' as asn1_integer;
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart'
    as asn1_sequence;
import 'package:pointycastle/export.dart' as pc;

class RSAKeyHelper {
  static Future<
      ({
        String publicKey,
        String privateKey,
      })> generateRSAKeyPair() async {
    final keyParams =
        pc.RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 12);

    final secureRandom = pc.FortunaRandom();
    final seedSource = Uint8List.fromList(
        List.generate(32, (_) => DateTime.now().microsecond % 256));
    secureRandom.seed(pc.KeyParameter(seedSource));

    final keyGen = pc.RSAKeyGenerator()
      ..init(pc.ParametersWithRandom(keyParams, secureRandom));

    final pair = keyGen.generateKeyPair();
    final privateKey = pair.privateKey as pc.RSAPrivateKey;
    final publicKey = pair.publicKey as pc.RSAPublicKey;

    final publicKeyPem = _encodePublicKeyToPem(publicKey);
    final privateKeyPem = _encodePrivateKeyToPem(privateKey);

    return (publicKey: publicKeyPem, privateKey: privateKeyPem);
  }

  static String _encodePublicKeyToPem(pc.RSAPublicKey publicKey) {
    final pem = '''
-----BEGIN RSA PUBLIC KEY-----
${base64.encode(_encodePublicKey(publicKey))}
-----END RSA PUBLIC KEY-----
''';
    return pem;
  }

  static String _encodePrivateKeyToPem(pc.RSAPrivateKey privateKey) {
    final pem = '''
-----BEGIN RSA PRIVATE KEY-----
${base64.encode(_encodePrivateKey(privateKey))}
-----END RSA PRIVATE KEY-----
''';
    return pem;
  }

  static Uint8List _encodePublicKey(pc.RSAPublicKey publicKey) {
    final asn1Seq = asn1_sequence.ASN1Sequence();
    asn1Seq.add(asn1_integer.ASN1Integer(publicKey.modulus!));
    asn1Seq.add(asn1_integer.ASN1Integer(publicKey.exponent!));
    return asn1Seq.encode();
  }

  static Uint8List _encodePrivateKey(pc.RSAPrivateKey privateKey) {
    final asn1Seq = asn1_sequence.ASN1Sequence();
    asn1Seq.add(asn1_integer.ASN1Integer(BigInt.from(0)));
    asn1Seq.add(asn1_integer.ASN1Integer(privateKey.modulus!));
    asn1Seq.add(asn1_integer.ASN1Integer(privateKey.exponent!));
    asn1Seq.add(asn1_integer.ASN1Integer(privateKey.p!));
    asn1Seq.add(asn1_integer.ASN1Integer(privateKey.q!));
    asn1Seq.add(asn1_integer.ASN1Integer(privateKey.privateExponent!));
    return asn1Seq.encode();
  }

  static pc.RSAPublicKey parsePublicKeyFromPem(String pemString) {
    final rows = pemString
        .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
        .replaceAll('-----END RSA PUBLIC KEY-----', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');
    final keyBytes = base64.decode(rows);

    final asn1Parser = asn1_parser.ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as asn1_sequence.ASN1Sequence;

    if (topLevelSeq.elements == null || topLevelSeq.elements!.length < 2) {
      throw ArgumentError('Chave RSA pública inválida ou malformada.');
    }

    final modulus =
        (topLevelSeq.elements![0] as asn1_integer.ASN1Integer).integer;
    final exponent =
        (topLevelSeq.elements![1] as asn1_integer.ASN1Integer).integer;

    return pc.RSAPublicKey(modulus!, exponent!);
  }

  static pc.RSAPrivateKey parsePrivateKeyFromPem(String pemString) {
    final rows = pemString
        .replaceAll('-----BEGIN RSA PRIVATE KEY-----', '')
        .replaceAll('-----END RSA PRIVATE KEY-----', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');

    final keyBytes = base64.decode(rows);

    final asn1Parser = asn1_parser.ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as asn1_sequence.ASN1Sequence;

    if (topLevelSeq.elements == null || topLevelSeq.elements!.length < 6) {
      throw ArgumentError('Chave RSA privada inválida ou malformada.');
    }

    final version =
        (topLevelSeq.elements![0] as asn1_integer.ASN1Integer).integer;
    if (version != BigInt.zero) {
      throw ArgumentError('Versão incompatível para chave privada RSA.');
    }

    final modulus =
        (topLevelSeq.elements![1] as asn1_integer.ASN1Integer).integer;

    final privateExponent =
        (topLevelSeq.elements![2] as asn1_integer.ASN1Integer).integer;
    final p = (topLevelSeq.elements![3] as asn1_integer.ASN1Integer).integer;
    final q = (topLevelSeq.elements![4] as asn1_integer.ASN1Integer).integer;

    return pc.RSAPrivateKey(modulus!, privateExponent!, p!, q!);
  }

  static Uint8List signWithPrivateKey(
      Uint8List data, pc.RSAPrivateKey privateKey) {
    final sha256Digest = crypto.sha256.convert(data);
    final signer = pc.Signer('SHA-256/RSA')
      ..init(true, pc.PrivateKeyParameter<pc.RSAPrivateKey>(privateKey));

    final signature =
        signer.generateSignature(Uint8List.fromList(sha256Digest.bytes))
            as pc.RSASignature;
    return signature.bytes;
  }
}
