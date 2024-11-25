import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

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
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.help,
      child: Tooltip(
        richMessage: WidgetSpan(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onInverseSurface,
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
          color: theme.colorScheme.inverseSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        preferBelow: true,
        verticalOffset: 8,
        waitDuration: const Duration(milliseconds: 400),
        showDuration: const Duration(seconds: 5),
        child: Icon(
          Icons.info_outline,
          size: 18,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
