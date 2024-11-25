import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:pdfx/pdfx.dart';

class FilePreviewHelper {
  static void showPreviewModal({
    required BuildContext context,
    required Uint8List content,
    String? fileName,
  }) {
    if (kDebugMode) {
      print('DEBUG: Abrindo modal de preview para arquivo: $fileName');
    }
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
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

  static Widget _buildPreviewContent(Uint8List bytes) {
    try {
      if (_isPdfBytes(bytes)) {
        return _buildPdfPreview(bytes);
      } else if (_isImageBytes(bytes)) {
        return _buildImagePreview(bytes);
      } else {
        return _buildTextContent(_tryDecodeText(bytes));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao construir preview: $e');
      }
      return _buildErrorWidget('Não foi possível visualizar este arquivo');
    }
  }

  static String _tryDecodeText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } catch (_) {
      try {
        return latin1.decode(bytes);
      } catch (_) {
        return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
      }
    }
  }

  static bool _isImageBytes(List<int> bytes) {
    if (bytes.length < 4) return false;

    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }

    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return true;
    }

    return false;
  }

  static bool _isPdfBytes(List<int> bytes) {
    if (bytes.length < 5) return false;
    // Verifica a assinatura do PDF ('%PDF-')
    return bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46 && // F
        bytes[4] == 0x2D; // -
  }

  static Widget _buildPdfPreview(Uint8List bytes) {
    return FutureBuilder<PdfDocument>(
      future: PdfDocument.openData(bytes).catchError((error) {
        if (kDebugMode) {
          print('Erro ao abrir PDF: $error');
        }
        throw error;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget('Não foi possível carregar o PDF');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final pdfController = PdfController(
          document: Future.value(snapshot.data!),
        );

        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 450, // Ajustado para acomodar os botões
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: PdfView(
                  controller: pdfController,
                  scrollDirection: Axis.vertical,
                  pageSnapping: false,
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    pageLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorBuilder: (_, error) => _buildErrorWidget(
                      'Erro ao carregar página do PDF',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildNavigationButtons(pdfController),
          ],
        );
      },
    );
  }

  static Widget _buildNavigationButtons(PdfController controller) {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder<PdfDocument>(
          future: controller.document,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            final totalPages = snapshot.data!.pagesCount;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: () => controller.jumpToPage(0),
                  tooltip: 'Primeira página',
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () => controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  tooltip: 'Página anterior',
                ),
                ValueListenableBuilder<int>(
                  valueListenable: controller.pageListenable,
                  builder: (context, value, _) {
                    final currentPage = value + 1;
                    return Text(
                      '$currentPage de $totalPages',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey900,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () => controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  tooltip: 'Próxima página',
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: () => controller.jumpToPage(totalPages - 1),
                  tooltip: 'Última página',
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildImagePreview(Uint8List bytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print('Erro ao carregar imagem: $error');
          }
          return _buildErrorWidget('Não foi possível carregar a imagem');
        },
      ),
    );
  }

  static Widget _buildErrorWidget(String message) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.grey700,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTextContent(String content) {
    if (kDebugMode) {
      print(
          'DEBUG: Renderizando como texto. Tamanho: ${content.length} caracteres');
    }
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
      if (kDebugMode) {
        print('Erro ao salvar arquivo: $e');
      }
      rethrow;
    }
  }
}
