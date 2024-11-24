import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preview_file/preview_file.dart';
import '../theme/app_spacing.dart';
import '../theme/app_colors.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class FilePreviewDialog extends StatefulWidget {
  final List<FilePreviewItem> files;
  final int initialIndex;

  const FilePreviewDialog({
    super.key,
    required this.files,
    this.initialIndex = 0,
  });

  static Future<void> show(
    BuildContext context, {
    required List<FilePreviewItem> files,
    int initialIndex = 0,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: FilePreviewDialog(
              files: files,
              initialIndex: initialIndex,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<FilePreviewDialog> createState() => _FilePreviewDialogState();
}

class _FilePreviewDialogState extends State<FilePreviewDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.files.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    return _FilePreviewContent(
                      file: widget.files[index],
                      key: ValueKey(widget.files[index].fileName),
                    );
                  },
                ),
                if (widget.files.length > 1) _buildNavigationControls(),
              ],
            ),
          ),
          if (widget.files.length > 1) _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentFile = widget.files[_currentIndex];
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.file_present,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        currentFile.fileName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tamanho: ${currentFile.fileSize}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.grey700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      children: [
        _NavigationButton(
          icon: Icons.chevron_left,
          onPressed: _currentIndex > 0
              ? () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
              : null,
        ),
        const Spacer(),
        _NavigationButton(
          icon: Icons.chevron_right,
          onPressed: _currentIndex < widget.files.length - 1
              ? () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
              : null,
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.files.length; i++)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(
              icon,
              size: 24,
              color: onPressed != null ? AppColors.primary : AppColors.grey300,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilePreviewContent extends StatefulWidget {
  final FilePreviewItem file;

  const _FilePreviewContent({
    super.key,
    required this.file,
  });

  @override
  State<_FilePreviewContent> createState() => _FilePreviewContentState();
}

class _FilePreviewContentState extends State<_FilePreviewContent> {
  late Future<File> _fileFuture;

  static const _textFileExtensions = [
    '.txt',
    '.md',
    '.json',
    '.xml',
    '.yml',
    '.css',
    '.js',
    '.log',
    '.ini',
    '.conf',
    '.env',
    '.sh',
    '.bat',
    '.properties',
  ];

  bool get _isTextFile {
    final fileName = widget.file.fileName.toLowerCase();
    return _textFileExtensions.any((ext) => fileName.endsWith(ext));
  }

  @override
  void initState() {
    super.initState();
    _fileFuture = _createTempFile(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Erro ao abrir o arquivo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Carregando arquivo...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.file.fileName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        if (_isTextFile) {
          return _buildTextFilePreview(snapshot.data!);
        }

        return Container(
          color: Colors.white,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilePreview(
                filePath: snapshot.data!.path,
                width: MediaQuery.of(context).size.width,
              ).preview(),
            ),
          ),
        );
      },
    );
  }

  String _getLanguageFromExtension(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'js':
        return 'javascript';
      case 'json':
        return 'json';
      case 'xml':
        return 'xml';
      case 'yml':
      case 'yaml':
        return 'yaml';
      case 'css':
        return 'css';
      case 'md':
        return 'markdown';
      default:
        return 'plaintext';
    }
  }

  Widget _buildTextFilePreview(File file) {
    return FutureBuilder<String>(
      future: file.readAsString(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao ler o arquivo de texto: ${snapshot.error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.file.fileName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey700,
                            fontFamily: 'monospace',
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  HighlightView(
                    snapshot.data!,
                    language: _getLanguageFromExtension(widget.file.fileName),
                    theme: githubTheme,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<File> _createTempFile(FilePreviewItem file) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${file.fileName}');
    await tempFile.writeAsBytes(file.fileBytes);
    return tempFile;
  }
}

class FilePreviewItem {
  final String fileName;
  final String fileSize;
  final List<int> fileBytes;

  const FilePreviewItem({
    required this.fileName,
    required this.fileSize,
    required this.fileBytes,
  });
}
