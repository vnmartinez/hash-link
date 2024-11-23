import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPressedBack;
  final VoidCallback? onPressedNext;
  final String? nextLabel;
  final Color? nextBackgroundColor;
  final bool showNextButton;
  final bool showBackButton;
  final bool enableBackButton;
  final bool enableNextButton;

  const ActionButtons({
    super.key,
    required this.onPressedBack,
    this.onPressedNext,
    this.nextLabel = 'Próximo',
    this.nextBackgroundColor = AppColors.primary,
    this.showNextButton = true,
    this.showBackButton = true,
    this.enableBackButton = true,
    this.enableNextButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _getMainAxisAlignment(),
      children: [
        if (showBackButton) _buildBackButton(),
        if (showNextButton) _buildNextButton(),
      ],
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    if (showBackButton && showNextButton) {
      return MainAxisAlignment.spaceBetween;
    } else if (!showBackButton && !showNextButton) {
      return MainAxisAlignment.center;
    } else if (showNextButton && !showBackButton) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }

  Widget _buildBackButton() {
    return ElevatedButton.icon(
      onPressed: enableBackButton ? onPressedBack : null,
      icon: const Icon(Icons.arrow_back, size: 20),
      label: const Text(
        'Voltar',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey300,
        foregroundColor: AppColors.grey700,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton.icon(
      onPressed: enableNextButton ? onPressedNext : null,
      icon: const Icon(Icons.arrow_forward, size: 20),
      label: Text(
        nextLabel!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: nextBackgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }
}
