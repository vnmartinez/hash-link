import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hash_link/views/decrypt/decrypt_view.dart';
import 'package:hash_link/views/encrypt/generate_key_view.dart';
import 'package:hash_link/widgets/page_header.dart';
import 'package:hash_link/theme/app_colors.dart';
import 'package:hash_link/theme/app_spacing.dart';
import 'package:hash_link/widgets/app_footer.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  static const route = '/initial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.xl,
                  vertical: AppSpacing.xl,
                ),
                children: [
                  const PageHeader(
                    title: 'Segurança de Sistemas',
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
                  SizedBox(
                      height: isSmallScreen ? AppSpacing.xl : AppSpacing.xxl),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: 1.0,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              AppColors.grey50,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            isSmallScreen ? AppSpacing.lg : AppSpacing.xl,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'O que você deseja fazer?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.grey900,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      description:
                                          'Recupere arquivos protegidos',
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
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppFooter(isSmallScreen: isSmallScreen),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1.5,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey200.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              HapticFeedback.lightImpact();
              onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.grey700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
