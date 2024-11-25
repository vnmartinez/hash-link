import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class KeyDownloadHelper {
  static Future<void> downloadPublicKey(String publicKey) async {
    const String fileName = 'public_key.pem';
    await _saveFile(publicKey, fileName);
  }

  static Future<void> downloadPrivateKey(String privateKey) async {
    const String fileName = 'private_key.pem';
    await _saveFile(privateKey, fileName);
  }

  static Future<void> downloadSymmetricKey(String symmetricKey) async {
    const String fileName = 'symmetric.key';
    await _saveFile(symmetricKey, fileName);
  }

  static Future<void> _saveFile(String content, String fileName) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Selecione onde salvar o arquivo',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [fileName.split('.').last],
        lockParentWindow: true,
      );

      if (outputFile == null) {
        return;
      }

      if (!outputFile.endsWith(fileName.split('.').last)) {
        outputFile = '$outputFile.${fileName.split('.').last}';
      }

      final File file = File(outputFile);
      await file.writeAsBytes(Uint8List.fromList(content.codeUnits));
    } catch (e) {
      rethrow;
    }
  }
}
