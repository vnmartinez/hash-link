import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    this.title = 'Segurança de Sistemas',
    this.subtitle = 'Criptografia e Assinatura Digital',
    this.features = const [
      (
        'Chaves RSA',
        Icons.key,
        'Sistema de criptografia assimétrica usando par de chaves pública e privada'
      ),
      (
        'Chave AES',
        Icons.enhanced_encryption,
        'Algoritmo de criptografia simétrica para dados sensíveis'
      ),
      (
        'Assinatura Digital',
        Icons.verified_user,
        'Mecanismo que garante autenticidade e integridade dos documentos'
      ),
      (
        'Hash',
        Icons.fingerprint,
        'Função que gera uma impressão digital única dos dados'
      ),
      (
        'Cifragem',
        Icons.lock,
        'Processo de transformar dados em formato ilegível'
      ),
      (
        'Verificação',
        Icons.security,
        'Validação da autenticidade e integridade dos dados'
      ),
      (
        'Criptografia',
        Icons.privacy_tip,
        'Técnicas para proteger a confidencialidade das informações'
      ),
    ],
    this.logoPath,
  });

  final String title;
  final String subtitle;
  final List<(String, IconData, String)> features;
  final String? logoPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            AppColors.accent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        subtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (logoPath != null) ...[
                const SizedBox(width: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xxs),
                    child: Image.asset(
                      logoPath!,
                      height: 80,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: features
          .map((feature) => _buildFeatureItem(
                icon: feature.$2,
                text: feature.$1,
                tooltip: feature.$3,
              ))
          .toList(),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    String? tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip ?? text,
        textStyle: AppTypography.bodySmall.copyWith(color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  text,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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
