import 'package:file_selector/file_selector.dart';
import 'dart:typed_data';

class KeyDownloadHelper {
  static Future<void> downloadPublicKey(String publicKey) async {
    const String suggestedName = 'public_key.pem';
    await _saveFile(publicKey, suggestedName);
  }

  static Future<void> downloadPrivateKey(String privateKey) async {
    const String suggestedName = 'private_key.pem';
    await _saveFile(privateKey, suggestedName);
  }

  static Future<void> downloadSymmetricKey(List<int> symmetricKey) async {
    const String suggestedName = 'aes_key.key';
    await _saveFile(symmetricKey.join(' '), suggestedName);
  }

  static Future<void> _saveFile(String content, String suggestedName) async {
    final FileSaveLocation? saveLocation = await getSaveLocation(
      suggestedName: suggestedName,
    );

    if (saveLocation == null) {
      return;
    }

    final String path = saveLocation.path;
    final Uint8List fileData = Uint8List.fromList(content.codeUnits);
    final XFile textFile = XFile.fromData(
      fileData,
      mimeType: 'text/plain',
      name: suggestedName,
    );

    await textFile.saveTo(path);
  }
}
