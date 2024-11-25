import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/theme/app_colors.dart';
import 'package:hash_link/theme/app_spacing.dart';
import 'package:hash_link/widgets/educational_widgets.dart';
import 'package:hash_link/widgets/section_title.dart';

import '../../../widgets/custom_toast.dart';
import '../../../helpers/file_preview_helper.dart';
import 'dart:typed_data';
import 'dart:convert';

class DecryptionSubview extends StatelessWidget {
  static const Map<String, Map<String, dynamic>> decryptionDetailedInfo = {
    'O que é?': {
      'content': '''
      A descriptografia é o processo de recuperar o conteúdo original de um arquivo 
      que foi previamente cifrado. No nosso caso, envolve a recuperação da chave 
      AES usando a chave privada RSA do professor.
      ''',
      'icon': Icons.lock_open,
      'examples': [
        'Leitura de documentos cifrados',
        'Recuperação de mensagens seguras',
      ],
    },
    'Como funciona?': {
      'content': '''
      • O professor fornece sua chave privada RSA
      • A chave privada é usada para descriptografar a chave AES
      • Com a chave AES, o arquivo é descriptografado
      • A assinatura digital é verificada para garantir autenticidade
      ''',
      'icon': Icons.settings,
      'steps': [
        'Recuperação da chave AES',
        'Descriptografia do arquivo',
        'Verificação da assinatura',
      ],
    },
  };

  const DecryptionSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final theme = Theme.of(context);

        return ListView(
          padding: EdgeInsets.only(
            left: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
            right: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
            bottom: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
          ),
          children: [
            SectionTitle(
              title: 'Verificação e Descriptografia',
              subtitle: 'Recupere o conteúdo original do arquivo cifrado',
              titleStyle: theme.textTheme.headlineSmall?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
              subtitleStyle: theme.textTheme.bodyMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? AppSpacing.lg : AppSpacing.xl),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    isSmallScreen ? AppSpacing.md : AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKeySelection(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    _buildProcessSteps(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    _buildActionButton(context),
                    _buildProcessStatus(),
                    const SizedBox(height: AppSpacing.lg),
                    const EnhancedEducationalSection(
                      title: 'Sobre Descriptografia',
                      sections: decryptionDetailedInfo,
                      icon: Icons.school,
                      initiallyExpanded: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKeySelection(ThemeData theme, bool isSmallScreen) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasKey =
            state is Decryption && state.teacherPrivateKeyFile != null;
        final fileName =
            state is Decryption ? state.teacherPrivateKeyFile?.name ?? '' : '';

        return Container(
          padding:
              EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.key,
                    color: hasKey ? AppColors.primary : AppColors.grey700,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Chave Privada do Professor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (hasKey)
                Text(
                  'Arquivo selecionado: ${fileName.split('/').last}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey700,
                  ),
                )
              else
                Text(
                  'Nenhuma chave selecionada',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<GenerateKeyBloc>()
                        .add(const SelectTeacherPrivateKeyFile());
                    if (state is Decryption &&
                        state.teacherPrivateKeyFile != null) {
                      CustomToast.show(
                        context,
                        'Chave privada selecionada com sucesso!',
                        type: ToastType.success,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasKey
                        ? AppColors.success.withOpacity(0.8)
                        : AppColors.grey200,
                    foregroundColor: hasKey ? Colors.white : AppColors.grey900,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(hasKey ? Icons.check : Icons.upload_file),
                  label: Text(
                    hasKey ? 'Chave selecionada' : 'Selecionar chave privada',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProcessSteps(ThemeData theme, bool isSmallScreen) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasKey =
            state is Decryption && state.teacherPrivateKeyFile != null;
        final isDecrypted = state is Decryption && state.validDecryption;

        return Container(
          padding:
              EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Processo de Descriptografia',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem(
                icon: Icons.key,
                text: 'Fornecer chave privada RSA',
                isDone: hasKey,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStepItem(
                icon: Icons.lock_open,
                text: 'Descriptografar arquivo',
                isDone: isDecrypted,
                isDisabled: !hasKey,
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String text,
    bool isDone = false,
    bool isDisabled = false,
    required ThemeData theme,
  }) {
    final color = isDone
        ? AppColors.primary
        : isDisabled
            ? AppColors.grey300
            : AppColors.grey700;

    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle : icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        if (state is! Decryption) return const SizedBox.shrink();

        return Center(
          child: SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: state.validDecryption
                  ? null
                  : () =>
                      context.read<GenerateKeyBloc>().add(const CheckPackage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.validDecryption
                    ? AppColors.success.withOpacity(0.7)
                    : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(state.validDecryption
                      ? Icons.check_circle
                      : Icons.lock_open),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    state.validDecryption
                        ? 'Descriptografia concluída'
                        : 'Iniciar Descriptografia',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessStatus() {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        if (state is! Decryption ||
            (!state.validDecryption && state.decryptedContent == null)) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,
                      color: AppColors.success.withOpacity(0.8)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Descriptografia concluída com sucesso!',
                    style: TextStyle(
                      color: AppColors.success.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'O arquivo foi descriptografado e a assinatura digital foi verificada.',
                style: TextStyle(
                  color: AppColors.success.withOpacity(0.8),
                ),
              ),
              if (state.decryptedContent != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Arquivo descriptografado: ${state.decryptedFileName}',
                  style: TextStyle(
                    color: AppColors.success.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => FilePreviewHelper.showPreviewModal(
                          context: context,
                          content: state.decryptedContent!,
                          fileName: state.decryptedFileName,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.lg,
                          ),
                        ),
                        icon: const Icon(Icons.visibility),
                        label: const Text('Visualizar'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      ElevatedButton.icon(
                        onPressed: () {
                          try {
                            final content = state.decryptedContent!;
                            Uint8List bytes;

                            try {
                              // Primeiro tenta decodificar como base64
                              bytes = base64Decode(content);
                            } catch (_) {
                              // Se falhar, usa os bytes do texto diretamente
                              bytes = Uint8List.fromList(utf8.encode(content));
                            }

                            FilePreviewHelper.saveFile(
                              bytes: bytes,
                              fileName: state.decryptedFileName ??
                                  'arquivo_descriptografado.bin',
                            );
                          } catch (e) {
                            CustomToast.show(
                              context,
                              'Erro ao salvar arquivo: $e',
                              type: ToastType.error,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.lg,
                          ),
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text('Baixar'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
