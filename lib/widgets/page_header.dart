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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
          stops: [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.low,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    subtitle,
                    style:
                        AppTypography.bodyMedium.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  alignment: WrapAlignment.start,
                  children: features
                      .map((feature) =>
                          _buildFeatureItem(feature.$2, feature.$1, feature.$3))
                      .toList(),
                ),
              ],
            ),
          ),
          if (logoPath != null) ...[
            const SizedBox(width: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.asset(
                logoPath!,
                height: 120,
                width: 240,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, [String? tooltip]) {
    return Tooltip(
      message: tooltip ?? text,
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
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
