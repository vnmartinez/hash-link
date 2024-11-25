import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hash_link/theme/app_colors.dart';
import 'package:hash_link/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class DevelopersModal extends StatelessWidget {
  const DevelopersModal({super.key});

  Widget _buildDeveloperInfo(String name, String githubUrl, String linkedinUrl,
      [String? role]) {
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey900,
                  ),
                ),
                if (role != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(linkedinUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: const Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.linkedin,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'LinkedIn',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(githubUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: const Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.github,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'GitHub',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.grey900,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey700,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDeveloperInfo(
                'Gabriel Pagotto',
                'https://github.com/gabrielpagotto',
                'https://www.linkedin.com/in/gabrielpagotto/'),
            const Divider(height: AppSpacing.xl),
            _buildDeveloperInfo(
                'Luciano Martins',
                'https://github.com/lucianomartinsjr',
                'https://www.linkedin.com/in/lucianomartinsjr/'),
            const Divider(height: AppSpacing.xl),
            _buildDeveloperInfo(
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
          child: const Text(
            'Fechar',
            style: TextStyle(color: AppColors.grey700),
          ),
        ),
      ],
    );
  }
}
