import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import 'package:hash_link/helpers/file_reader_helper.dart';
import 'package:hash_link/widgets/section_title.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class PreparationSubview extends StatelessWidget {
  const PreparationSubview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return ListView(
          padding:
              EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
          children: [
            SectionTitle(
              title: 'Preparação de ambiente',
              subtitle:
                  'Importe os arquivos necessários para o processo de criptografia',
              titleStyle: theme.textTheme.headlineSmall?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
              subtitleStyle: theme.textTheme.bodyMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? AppSpacing.lg : AppSpacing.xl),
            if (isSmallScreen) ...[
              _buildImportSection(context, theme, isSmallScreen),
              const SizedBox(height: AppSpacing.lg),
              _buildFileSection(context, theme, isSmallScreen),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildImportSection(context, theme, isSmallScreen),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _buildFileSection(context, theme, isSmallScreen),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildImportSection(
      BuildContext context, ThemeData theme, bool isSmallScreen) {
    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
        child: BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            final file =
                state is Preparation ? state.teacherPublicKeyFile : null;
            final selecting =
                state is Preparation && state.selectingTeacherPublicKeyFile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.upload_file, color: AppColors.primary),
                    SizedBox(
                        width: isSmallScreen ? AppSpacing.sm : AppSpacing.md),
                    Text(
                      'Chave Pública do Destinatário',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: isSmallScreen ? 18 : 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Importe a chave pública fornecida pelo destinatário',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        file != null ? AppColors.primary : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: selecting
                      ? null
                      : () => context
                          .read<GenerateKeyBloc>()
                          .add(const SelectTeacherPublicKeyFile()),
                  icon: Icon(file != null ? Icons.check : Icons.file_upload),
                  label: Text(
                    file != null ? 'Arquivo importado' : 'Escolher arquivo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (selecting)
                  const LinearProgressIndicator(
                    backgroundColor: AppColors.grey200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                if (file != null)
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isValidFile(file)
                            ? AppColors.primary
                            : AppColors.error,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isValidFile(file) ? Icons.check_circle : Icons.error,
                          color: _isValidFile(file)
                              ? AppColors.primary
                              : AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Arquivo selecionado:',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                file.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (!_isValidFile(file))
                                Text(
                                  _getFileErrorMessage(file) ??
                                      'Formato de arquivo inválido',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => context
                              .read<GenerateKeyBloc>()
                              .add(ClearSelectedFile()),
                          tooltip: 'Remover arquivo',
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFileSection(
      BuildContext context, ThemeData theme, bool isSmallScreen) {
    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
        child: BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            final file = state is Preparation ? state.fileToSend : null;
            final selecting = state is Preparation && state.selectingFileToSend;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.upload_file, color: AppColors.primary),
                    SizedBox(
                        width: isSmallScreen ? AppSpacing.sm : AppSpacing.md),
                    Text(
                      'Arquivo para envio',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: isSmallScreen ? 18 : 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Selecione o arquivo que deseja enviar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
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
                  onPressed: selecting
                      ? null
                      : () => context
                          .read<GenerateKeyBloc>()
                          .add(const SelectFileToSend()),
                  icon: const Icon(Icons.file_upload),
                  label: const Text(
                    'Escolher arquivo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (selecting)
                  const LinearProgressIndicator(
                    backgroundColor: AppColors.grey200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                if (file != null)
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Arquivo selecionado:',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                file.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => context
                              .read<GenerateKeyBloc>()
                              .add(ClearSelectedFile()),
                          tooltip: 'Remover arquivo',
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isValidFile(FileReader? file) {
    if (file == null) return false;

    try {
      final extension = file.name.split('.').last.toLowerCase();
      final validExtensions = ['aes', 'rsa', 'pem', 'pub'];

      final fileSize = int.tryParse(file.size) ?? 0;
      if (fileSize > 1024 * 1024) return false;

      return validExtensions.contains(extension);
    } catch (e) {
      if (kDebugMode) {
        print('Erro na validação do arquivo: $e');
      }
      return false;
    }
  }

  String? _getFileErrorMessage(FileReader? file) {
    if (file == null) return 'Nenhum arquivo selecionado';

    try {
      final extension = file.name.split('.').last.toLowerCase();
      final validExtensions = ['aes', 'rsa', 'pem', 'pub'];

      final fileSize = int.tryParse(file.size) ?? 0;
      if (fileSize > 1024 * 1024) {
        return 'Tamanho do arquivo excede o limite de 1MB';
      }

      if (!validExtensions.contains(extension)) {
        return 'Formato de arquivo inválido. Formatos aceitos: ${validExtensions.join(", ")}';
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro na validação do arquivo: $e');
      }
      return 'Erro ao validar o arquivo: ${e.toString()}';
    }
  }
}
