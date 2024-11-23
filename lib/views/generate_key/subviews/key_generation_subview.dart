import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/widgets/section_title.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';

import '../../../theme/app_spacing.dart';
import 'package:hash_link/helpers/key_download_helper.dart';
import 'package:file_selector/file_selector.dart';

class KeyGenerationSubview extends StatelessWidget {
  const KeyGenerationSubview({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copiado para a área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SectionTitle(
          title: 'Geração de Chaves',
          subtitle:
              'Gere as chaves necessárias para o processo de criptografia',
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.key, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Par de Chaves RSA',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Gere um par de chaves RSA para garantir a segurança da comunicação',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xl,
                                    vertical: AppSpacing.lg,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => context
                                    .read<GenerateKeyBloc>()
                                    .add(const GenerateRSAKeyPair()),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.vpn_key),
                                    SizedBox(width: AppSpacing.md),
                                    Text(
                                      'Gerar par de chaves RSA',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (state is KeyGeneration &&
                                  (state.publicKey != null ||
                                      state.privateKey != null))
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: AppSpacing.md),
                                  child: Column(
                                    children: [
                                      if (state.publicKey != null)
                                        _KeyCard(
                                          title: 'Chave Pública',
                                          content: state.publicKey!,
                                          onCopy: () => _copyToClipboard(
                                              context, state.publicKey!),
                                          onDownload: () => KeyDownloadHelper
                                              .downloadPublicKey(
                                                  state.publicKey!),
                                        ),
                                      const SizedBox(height: AppSpacing.md),
                                      if (state.privateKey != null)
                                        _KeyCard(
                                          title: 'Chave Privada',
                                          content: state.privateKey!,
                                          onCopy: () => _copyToClipboard(
                                              context, state.privateKey!),
                                          onDownload: () => KeyDownloadHelper
                                              .downloadPrivateKey(
                                                  state.privateKey!),
                                          isPrivate: true,
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Chave Simétrica AES',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Gere uma chave simétrica AES para cifrar os arquivos',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
                        builder: (context, state) {
                          final canGenerate = state is KeyGeneration &&
                              state.canGenerateSymmetricKey;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canGenerate
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  foregroundColor: canGenerate
                                      ? Colors.white
                                      : AppColors.grey500,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xl,
                                    vertical: AppSpacing.lg,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: canGenerate
                                    ? () => context
                                        .read<GenerateKeyBloc>()
                                        .add(const GenerateAESSymmetricKey())
                                    : null,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock),
                                    SizedBox(width: AppSpacing.md),
                                    Text(
                                      'Gerar chave simétrica AES',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (state is KeyGeneration &&
                                  state.symmetricKey != null)
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: AppSpacing.md),
                                  child: _KeyCard(
                                    title: 'Chave AES',
                                    content: state.symmetricKey!.join(' '),
                                    onCopy: () => _copyToClipboard(
                                        context, state.symmetricKey!.join(' ')),
                                    onDownload: () =>
                                        KeyDownloadHelper.downloadSymmetricKey(
                                            state.symmetricKey!),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeyCard extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onCopy;
  final VoidCallback onDownload;
  final bool isPrivate;

  const _KeyCard({
    required this.title,
    required this.content,
    required this.onCopy,
    required this.onDownload,
    this.isPrivate = false,
  });

  @override
  State<_KeyCard> createState() => _KeyCardState();
}

class _KeyCardState extends State<_KeyCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: AppColors.grey100,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: widget.onCopy,
                  tooltip: 'Copiar chave',
                ),
                IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  onPressed: widget.onDownload,
                  tooltip: 'Baixar chave',
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  tooltip: _isExpanded ? 'Ocultar chave' : 'Mostrar chave',
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                widget.content,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
