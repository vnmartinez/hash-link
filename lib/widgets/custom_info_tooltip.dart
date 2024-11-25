import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CustomInfoTooltip extends StatelessWidget {
  final String message;
  final double maxWidth;

  const CustomInfoTooltip({
    super.key,
    required this.message,
    this.maxWidth = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.help,
      child: Tooltip(
        richMessage: WidgetSpan(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.grey900.withOpacity(0.95),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        preferBelow: true,
        verticalOffset: 8,
        waitDuration: const Duration(milliseconds: 400),
        showDuration: const Duration(seconds: 5),
        child: const Icon(
          Icons.info_outline,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
