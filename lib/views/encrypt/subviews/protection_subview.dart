import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/custom_toast.dart';
import '../../../widgets/educational_widgets.dart';
import '../../../widgets/section_title.dart';
import '../encrypt_view.dart';

class ProtectionSubview extends StatelessWidget {
  static const Map<String, Map<String, dynamic>> protectionDetailedInfo = {
    'O que é?': {
      'content': '''
      A proteção da chave simétrica é um processo que garante o compartilhamento 
      seguro da chave AES usando criptografia assimétrica RSA.
      ''',
      'icon': Icons.shield,
    },
    'Como funciona?': {
      'content': '''
      • A chave AES (256 bits) é gerada de forma segura e aleatória
      • Esta chave é então cifrada usando a chave pública RSA (2048 bits) do destinatário
      • O resultado é uma versão protegida da chave AES em formato Base64
      • Quando o destinatário receber, usará sua chave privada RSA para descriptografar
      • Este processo garante que:
         - Apenas o destinatário correto pode acessar a chave AES
         - A chave está protegida durante a transmissão
         - O compartilhamento é seguro mesmo em canais não confiáveis
      ''',
      'icon': Icons.settings,
      'steps': [
        'Geração segura da chave AES',
        'Cifragem com RSA público',
        'Transmissão protegida',
        'Decifragem com RSA privado'
      ],
    },
  };

  const ProtectionSubview({super.key});

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
              title: 'Proteção da Chave Simétrica',
              subtitle:
                  'Proteja a chave AES usando criptografia assimétrica RSA',
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
              color: theme.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    isSmallScreen ? AppSpacing.md : AppSpacing.lg),
                child: Column(
                  children: [
                    _buildProtectionStatus(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: SizedBox(
                        width: 350,
                        child: BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
                          builder: (context, state) {
                            final hasProtection = state is Protection &&
                                state.symmetricKeyEncryption != null;

                            return ElevatedButton(
                              onPressed: () => context
                                  .read<GenerateKeyBloc>()
                                  .add(const ProtectAES()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hasProtection
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
                                disabledBackgroundColor: hasProtection
                                    ? AppColors.success.withOpacity(0.7)
                                    : AppColors.grey300,
                                disabledForegroundColor: hasProtection
                                    ? Colors.white
                                    : AppColors.grey500,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(hasProtection
                                      ? Icons.check_circle
                                      : Icons.shield),
                                  const SizedBox(width: AppSpacing.md),
                                  Flexible(
                                    child: Text(
                                      hasProtection
                                          ? 'Protegida com sucesso'
                                          : 'Proteger Chave Simétrica',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
                      builder: (context, state) {
                        if (state is! Protection ||
                            state.symmetricKeyEncryption == null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            _ProcessStatusCard(
                              title: 'Chave Simétrica Protegida',
                              content: state.symmetricKeyEncryption!,
                              icon: Icons.lock,
                              backgroundColor: AppColors.grey100,
                              borderColor: AppColors.grey300,
                              onCopy: () => _copyToClipboard(
                                  context, state.symmetricKeyEncryption!),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.timeline,
                                            color: AppColors.primary),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Fluxo de Proteção da Chave',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.xl),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildProcessStep(
                                          icon: Icons.key,
                                          label: 'Chave AES\nGerada',
                                          description: '256 bits',
                                          isActive: true,
                                        ),
                                        _buildArrow('Cifragem'),
                                        _buildProcessStep(
                                          icon: Icons.public,
                                          label: 'Chave RSA\nPública',
                                          description: '2048 bits',
                                          isActive: true,
                                        ),
                                        _buildArrow('Proteção'),
                                        _buildProcessStep(
                                          icon: Icons.enhanced_encryption,
                                          label: 'Chave AES\nProtegida',
                                          description: 'Base64',
                                          isActive: true,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                    Text(
                                      'A chave AES é cifrada usando a chave pública RSA do destinatário, garantindo que apenas ele possa descriptografá-la com sua chave privada.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.grey700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const EnhancedEducationalSection(
                      title: 'Sobre Proteção da Chave',
                      sections: protectionDetailedInfo,
                      icon: Icons.school,
                      initiallyExpanded: false,
                    ),
                    const SecurityTips(
                      tips: [
                        'Certifique-se de usar a chave pública correta do destinatário',
                        'Mantenha a chave protegida em local seguro',
                        'Não compartilhe a chave por meios não seguros',
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

  Widget _buildProtectionStatus(ThemeData theme, bool isSmallScreen) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      builder: (context, state) {
        final hasProtection =
            state is Protection && state.symmetricKeyEncryption != null;

        return Container(
          padding:
              EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shield,
                    color: hasProtection
                        ? AppColors.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Status da Proteção',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem(
                icon: Icons.key,
                text: 'Gerar chave AES',
                isDone: state is Protection,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStepItem(
                icon: Icons.public,
                text: 'Obter chave pública RSA do destinatário',
                isDone: state is Protection,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStepItem(
                icon: Icons.enhanced_encryption,
                text: 'Proteger chave simétrica',
                isDone: hasProtection,
                isDisabled: state is! Protection,
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
            ? theme.colorScheme.outline
            : theme.colorScheme.onSurfaceVariant;

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

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    GenerateKeyView.showToast(
      context,
      'Copiado para a área de transferência',
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                onPressed: onCopy,
                icon: Icon(
                  Icons.copy,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildProcessStep({
  required IconData icon,
  required String label,
  required String description,
  required bool isActive,
}) {
  return Builder(builder: (context) {
    final theme = Theme.of(context);

    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primary : theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? AppColors.primary
                : theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive
                  ? AppColors.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildArrow(String label) {
  return Builder(builder: (context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_forward,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  });
}
