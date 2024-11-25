import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hash_link/theme/app_colors.dart';
import 'package:hash_link/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class DevelopersModal extends StatelessWidget {
  const DevelopersModal({super.key});

  Widget _buildDeveloperInfo(
      BuildContext context, String name, String githubUrl, String linkedinUrl,
      [String? role]) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                if (role != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.grey300 : AppColors.grey700,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildSocialButton(
                      context: context,
                      icon: FontAwesomeIcons.linkedin,
                      label: 'LinkedIn',
                      url: linkedinUrl,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _buildSocialButton(
                      context: context,
                      icon: FontAwesomeIcons.github,
                      label: 'GitHub',
                      url: githubUrl,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.people_outline,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Desenvolvedores',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.textTheme.titleLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conheça nossa equipe:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDeveloperInfo(
                context,
                'Gabriel Pagotto',
                'https://github.com/gabrielpagotto',
                'https://www.linkedin.com/in/gabrielpagotto/'),
            Divider(
              height: AppSpacing.xl,
              color: isDark ? AppColors.grey700 : AppColors.grey200,
            ),
            _buildDeveloperInfo(
                context,
                'Luciano Martins',
                'https://github.com/lucianomartinsjr',
                'https://www.linkedin.com/in/lucianomartinsjr/'),
            Divider(
              height: AppSpacing.xl,
              color: isDark ? AppColors.grey700 : AppColors.grey200,
            ),
            _buildDeveloperInfo(
                context,
                'Vinicius Martinez',
                'https://github.com/vnmartinez',
                'https://www.linkedin.com/in/martinezvinicius/'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          child: Text(
            'Fechar',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
