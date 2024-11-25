import 'package:flutter/material.dart';
import 'package:hash_link/theme/app_spacing.dart';
import 'package:hash_link/widgets/developers_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
    this.isSmallScreen = false,
  });

  final bool isSmallScreen;

  Widget _buildFooterButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black.withOpacity(0.05)),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFooterButton(
            context: context,
            icon: Icons.code,
            label: 'Código Fonte',
            onTap: () => launchUrl(
              Uri.parse('https://github.com/vnmartinez/hash_link'),
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          _buildFooterButton(
            context: context,
            icon: Icons.people_outline,
            label: 'Desenvolvedores',
            onTap: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => const DevelopersModal(),
            ),
          ),
        ],
      ),
    );
  }
}
