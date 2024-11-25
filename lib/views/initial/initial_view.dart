import 'package:flutter/material.dart';
import 'package:hash_link/views/decrypt/decrypt_view.dart';
import 'package:hash_link/views/encrypt/generate_key_view.dart';
import 'package:hash_link/widgets/page_header.dart';
import 'package:hash_link/theme/app_colors.dart';
import 'package:hash_link/theme/app_spacing.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  static const route = '/initial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.xl,
              vertical: AppSpacing.xl,
            ),
            children: [
              const PageHeader(
                title: 'Hash Link',
                subtitle: 'Sistema de Criptografia e Assinatura Digital',
                logoPath: 'assets/images/logo.png',
                features: [
                  (
                    'Criptografia',
                    Icons.lock,
                    'Proteja seus arquivos com criptografia avançada'
                  ),
                  (
                    'Descriptografia',
                    Icons.lock_open,
                    'Recupere arquivos criptografados com segurança'
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? AppSpacing.xl : AppSpacing.xxl),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    isSmallScreen ? AppSpacing.lg : AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'O que você deseja fazer?',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey900,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              icon: Icons.enhanced_encryption,
                              label: 'Criptografar Arquivo',
                              description:
                                  'Proteja seus arquivos com criptografia segura',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                GenerateKeyView.route,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              icon: Icons.lock_open,
                              label: 'Descriptografar Arquivo',
                              description: 'Recupere arquivos protegidos',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                DecryptView.route,
                              ),
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary ? AppColors.primary : AppColors.grey300,
          width: 2,
        ),
        color: isPrimary ? AppColors.primary.withOpacity(0.05) : Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isPrimary ? AppColors.primary : AppColors.grey200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary ? Colors.white : AppColors.grey700,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? AppColors.primary : AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isPrimary ? AppColors.grey700 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
