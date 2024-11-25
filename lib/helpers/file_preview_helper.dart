import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePreviewHelper {
  static void showPreviewModal({
    required BuildContext context,
    required String content,
    String? fileName,
  }) {
    print('DEBUG: Abrindo modal de preview para arquivo: $fileName');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 800,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visualização do Arquivo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey900,
                            ),
                          ),
                          if (fileName != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey700,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: AppColors.grey700,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(height: 1),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: _buildPreviewContent(content),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildPreviewContent(String content) {
    try {
      // Primeiro, tenta decodificar o conteúdo como base64
      final bytes = base64Decode(content);

      // Tenta detectar se é uma imagem válida
      if (_isImageBytes(bytes)) {
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildTextContent(_tryDecodeText(bytes));
          },
        );
      } else {
        // Se não for uma imagem, tenta decodificar como texto
        return _buildTextContent(_tryDecodeText(bytes));
      }
    } catch (e) {
      // Se falhar a decodificação base64, mostra o conteúdo bruto
      return _buildTextContent(content);
    }
  }

  static String _tryDecodeText(List<int> bytes) {
    try {
      // Tenta diferentes codificações
      return utf8.decode(bytes);
    } catch (_) {
      try {
        return latin1.decode(bytes);
      } catch (_) {
        // Se todas as tentativas falharem, retorna representação hexadecimal
        return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
      }
    }
  }

  static bool _isImageBytes(List<int> bytes) {
    if (bytes.length < 4) return false;

    // PNG signature
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }

    // JPEG signature
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return true;
    }

    return false;
  }

  static Widget _buildTextContent(String content) {
    print(
        'DEBUG: Renderizando como texto. Tamanho: ${content.length} caracteres');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SelectableText(
        content,
        style: const TextStyle(
          color: AppColors.grey900,
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  static Future<void> saveFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Selecione onde salvar o arquivo',
        fileName: fileName,
        type: FileType.any,
      );

      if (outputFile == null) {
        return;
      }

      final File file = File(outputFile);
      await file.writeAsBytes(bytes);
    } catch (e) {
      print('Erro ao salvar arquivo: $e');
      rethrow;
    }
  }
}
