import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import '../../../widgets/file_preview.dart';
import '../../../helpers/file_reader_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/custom_toast.dart';
import '../../../widgets/educational_widgets.dart';
import '../../../widgets/section_title.dart';
import '../encrypt_view.dart';

class SignatureSubview extends StatelessWidget {
  static const Map<String, Map<String, dynamic>> signatureDetailedInfo = {
    'O que é?': {
      'content': '''
      A assinatura digital é um mecanismo criptográfico que garante autenticidade, 
      integridade e não-repúdio de documentos digitais. É como uma assinatura manuscrita, 
      mas com garantias matemáticas de segurança.
      ''',
      'icon': Icons.verified_user,
      'examples': [
        'Assinatura de contratos digitais',
        'Validação de documentos oficiais',
      ],
    },
    'Como funciona?': {
      'content': '''
      • Calcula um hash único (como uma impressão digital) do documento
      • Criptografa esse hash usando sua chave privada RSA (criando a assinatura)
      • Criptografa o documento usando uma chave AES (para confidencialidade)
      • Combina o documento cifrado com a assinatura
      • Permite que outros verifiquem a autenticidade usando sua chave pública
      • Garante que o documento não foi alterado após a assinatura
      ''',
      'icon': Icons.settings,
      'steps': [
        'Geração do hash SHA-256',
        'Assinatura com RSA',
        'Cifragem com AES-256',
        'Verificação da integridade',
      ],
    },
    'Analogia': {
      'content': '''
      Imagine um envelope lacrado (cifragem AES) com um selo especial (assinatura RSA).
      O selo garante quem enviou e o envelope protege o conteúdo.
      ''',
      'icon': Icons.lightbulb_outline,
    },
    'Aplicações Práticas': {
      'content': '''
      • Assinatura de contratos digitais
      • Notas fiscais eletrônicas
      • Documentos governamentais
      • Processos judiciais eletrônicos
      • Transações bancárias
      ''',
      'icon': Icons.work,
    },
    'Cuidados Importantes': {
      'content': '''
      • Proteja sempre a chave privada
      • Verifique certificados digitais
      • Mantenha backups seguros
      ''',
      'icon': Icons.warning_amber,
    },
  };

  const SignatureSubview({super.key});

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
              title: 'Assinatura e Cifragem',
              subtitle:
                  'Proteja seu arquivo com assinatura digital e criptografia',
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
                    _buildFileSelection(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    _buildProcessSteps(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    _buildActionButton(context),
                    _buildProcessStatus(),
                    const SizedBox(height: AppSpacing.lg),
                    const EnhancedEducationalSection(
                      title: 'Sobre Assinatura Digital',
                      sections: signatureDetailedInfo,
                      icon: Icons.school,
                      initiallyExpanded: false,
                    ),
                    const SecurityTips(
                      tips: [
                        'Mantenha sua chave privada segura',
                        'Verifique a integridade do arquivo após a cifragem',
                        'Faça backup do arquivo cifrado',
                        'Use apenas chaves RSA geradas nesta sessão',
                      ],
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

  Widget _buildFileSelection(ThemeData theme, bool isSmallScreen) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasFile = state is Signature;

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
                    Icons.file_present,
                    color: hasFile ? AppColors.primary : AppColors.grey700,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Arquivo Selecionado',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (hasFile)
                _buildFilePreview(state.fileToSend.name, theme)
              else
                Text(
                  'Nenhum arquivo selecionado',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              if (!hasFile)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => context
                        .read<GenerateKeyBloc>()
                        .add(const SelectFileToSend()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey200,
                      foregroundColor: AppColors.grey900,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.file_upload),
                    label: const Text(
                      'Selecionar arquivo',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilePreview(String fileName, ThemeData theme) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        if (state is! Signature) return const SizedBox.shrink();

        return Row(
          children: [
            Expanded(
              child: Text(
                fileName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showFilePreview(context, state.fileToSend),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Pré-visualizar arquivo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilePreview(BuildContext context, FileReader file) {
    FilePreviewHelper.showPreviewModal(
      context: context,
      content: Uint8List.fromList(file.bytes),
      fileName: file.name,
    );
  }

  Widget _buildProcessSteps(ThemeData theme, bool isSmallScreen) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasFile = state is Signature;
        final hasKeys = state is Signature;

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
                'Processo de Assinatura',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem(
                icon: Icons.file_present,
                text: 'Selecionar arquivo para assinatura',
                isDone: hasFile,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStepItem(
                icon: Icons.key,
                text: 'Gerar chaves RSA',
                isDone: hasKeys,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStepItem(
                icon: Icons.enhanced_encryption,
                text: 'Assinar digitalmente',
                isDisabled: !hasFile || !hasKeys,
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

    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasSignature = state is Signature && state.fileSignature != null;
        final isSignStep = text.contains('Assinar digitalmente');

        if (isSignStep && hasSignature) {
          isDone = true;
        }

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
      },
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final canProceed = state is Signature;
        final hasSignature = state is Signature && state.fileSignature != null;

        if (hasSignature) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GenerateKeyView.showToast(
              context,
              'Arquivo assinado e cifrado com sucesso!',
              type: ToastType.success,
            );
          });
        }

        return Column(
          children: [
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: hasSignature
                      ? null
                      : canProceed
                          ? () => context
                              .read<GenerateKeyBloc>()
                              .add(const SignAndEncryptFile())
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasSignature
                        ? AppColors.success.withOpacity(0.7)
                        : canProceed
                            ? AppColors.primary
                            : AppColors.grey300,
                    foregroundColor: hasSignature || canProceed
                        ? Colors.white
                        : AppColors.grey500,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: hasSignature
                        ? AppColors.success.withOpacity(0.7)
                        : AppColors.grey300,
                    disabledForegroundColor:
                        hasSignature ? Colors.white : AppColors.grey500,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(hasSignature
                          ? Icons.check_circle
                          : Icons.enhanced_encryption),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        hasSignature
                            ? 'Assinado com sucesso'
                            : 'Assinar e Cifrar Documento',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is Signature && state.fileDigest != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: _ProcessStatusCard(
                  title: 'Hash do Arquivo',
                  content: state.fileDigest!,
                  icon: Icons.fingerprint,
                  backgroundColor: AppColors.grey100,
                  borderColor: AppColors.grey300,
                  onCopy: () => _copyToClipboard(context, state.fileDigest!),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProcessStatus() {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        if (state is! Signature) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(top: AppSpacing.lg),
          child: Column(
            children: [
              if (state.fileSignature != null)
                _ProcessStatusCard(
                  title: 'Assinatura Digital',
                  content: state.fileSignature!,
                  icon: Icons.verified,
                  backgroundColor: AppColors.grey100,
                  borderColor: AppColors.grey300,
                  onCopy: () => _copyToClipboard(context, state.fileSignature!),
                ),
              if (state.fileEncryption != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: _ProcessStatusCard(
                    title: 'Arquivo Cifrado',
                    content: state.fileEncryption!,
                    icon: Icons.lock,
                    backgroundColor: AppColors.grey100,
                    borderColor: AppColors.grey300,
                    onCopy: () =>
                        _copyToClipboard(context, state.fileEncryption!),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    GenerateKeyView.showToast(
      context,
      'Copiado para a área de transfer��ncia',
      type: ToastType.success,
    );
  }
}

class _ProcessStatusCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onCopy;

  const _ProcessStatusCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 1,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    content,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.grey700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              color: AppColors.grey700,
            ),
          ],
        ),
      ),
    );
  }
}
