import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class CustomInfoTooltip extends StatelessWidget {
  final String message;
  final double maxWidth;

  const CustomInfoTooltip({
    super.key,
    required this.message,
    this.maxWidth = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return MouseRegion(
      cursor: SystemMouseCursors.help,
      child: Tooltip(
        richMessage: WidgetSpan(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: screenSize.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.6,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.98),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        preferBelow: false,
        enableTapToDismiss: true,
        verticalOffset: 0,
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 30),
        textAlign: TextAlign.left,
        child: Icon(
          Icons.info_outline,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
