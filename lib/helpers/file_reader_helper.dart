import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
import 'package:hash_link/core/annotations.dart';

part 'file_reader_helper.freezed.dart';

@object
class FileReader with _$FileReader {
  const factory FileReader({
    required String name,
    required int length,
    required List<int> bytes,
    required String hash,
  }) = _FileReader;

  factory FileReader.fromPlatformFile(PlatformFile file) {
    final bytes = file.bytes ?? <int>[];
    final hash = crypto.sha256.convert(bytes).toString();
    return FileReader(name: file.name, length: file.size, bytes: bytes, hash: hash);
  }
}

extension FileReaderExtension on FileReader {
  String get size {
    final sizeInKB = (length / 1024).toStringAsFixed(2);
    return '$sizeInKB KB';
  }
}
