import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/educational_widgets.dart';
import '../../../widgets/section_title.dart';

class ShippingSubview extends StatelessWidget {
  static const Map<String, Map<String, dynamic>> shippingDetailedInfo = {
    'O que é?': {
      'content': '''
      O empacotamento e envio é o processo final onde todos os elementos 
      processados são combinados em um único pacote seguro para transmissão.
      ''',
      'icon': Icons.inventory_2,
    },
    'Como funciona?': {
      'content': '''
      • O arquivo cifrado com a chave AES é preparado
      • A assinatura digital do arquivo original é anexada
      • A chave simétrica protegida é incluída
      • Todos os elementos são combinados em um único pacote
      • O pacote é enviado de forma segura ao destinatário
      • Este processo garante:
         - Confidencialidade dos dados
         - Autenticidade do remetente
         - Integridade do conteúdo
      ''',
      'icon': Icons.settings,
      'steps': [
        'Preparação dos componentes',
        'Combinação em pacote',
        'Envio seguro',
        'Recebimento pelo destinatário'
      ],
    },
  };

  const ShippingSubview({super.key});

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
              title: 'Empacotamento e Envio',
              subtitle:
                  'Combine e envie os elementos processados de forma segura',
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
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    isSmallScreen ? AppSpacing.md : AppSpacing.lg),
                child: Column(
                  children: [
                    _buildPackageComponents(theme, isSmallScreen),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () => context
                                  .read<GenerateKeyBloc>()
                                  .add(const SendPackage()),
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: AppSpacing.md),
                                  Text(
                                    'Salvar Pacote',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Card(
                      elevation: 1,
                      color: theme.colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.swap_horiz,
                                    color: AppColors.primary),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Fluxo de Transmissão',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildParticipante(
                                  Icons.person,
                                  'Aluno',
                                  'Remetente',
                                  true,
                                ),
                                _buildArrow('Envio'),
                                _buildParticipante(
                                  Icons.person_outline,
                                  'Professor',
                                  'Destinatário',
                                  false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const EnhancedEducationalSection(
                      title: 'Sobre o Envio',
                      sections: shippingDetailedInfo,
                      icon: Icons.school,
                      initiallyExpanded: false,
                    ),
                    const SecurityTips(
                      tips: [
                        'Verifique todos os componentes antes do envio',
                        'Confirme o destinatário correto',
                        'Mantenha uma cópia de segurança do pacote',
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

  Widget _buildPackageComponents(ThemeData theme, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.md),
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
                Icons.inventory_2,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Componentes do Pacote',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildComponentItem(
            icon: Icons.lock,
            text: 'Arquivo cifrado com chave simétrica',
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildComponentItem(
            icon: Icons.fingerprint,
            text: 'Assinatura digital do arquivo original',
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildComponentItem(
            icon: Icons.key,
            text: 'Chave simétrica cifrada com RSA',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildComponentItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipante(
    IconData icon,
    String titulo,
    String subtitulo,
    bool isActive,
  ) {
    return Builder(builder: (context) {
      final theme = Theme.of(context);

      return Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant,
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
              titulo,
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
              subtitulo,
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
}
