import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';

class ZipData {
  final String name;
  final Uint8List bytes;

  const ZipData({required this.name, required this.bytes});
}

class ZipHelper {
  final FilePicker _filePicker;

  const ZipHelper({required FilePicker filePicker}) : _filePicker = filePicker;

  Future<void> zipAndSaveLocal(String zipName, List<ZipData> data) async {
    final encoder = ZipEncoder();
    final archive = Archive();

    for (final item in data) {
      archive.addFile(ArchiveFile(item.name, item.bytes.length, item.bytes));
    }

    final zipData = encoder.encode(archive);
    final outputFile = await _filePicker.saveFile(
      dialogTitle: 'Selecione onde salvar o arquivo',
      fileName: '$zipName.zip',
      type: FileType.custom,
      allowedExtensions: ['.zip'],
      lockParentWindow: true,
    );

    if (outputFile == null || zipData == null) return;

    final file = File(outputFile);
    await file.writeAsBytes(zipData);
  }
}
