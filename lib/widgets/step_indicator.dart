import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class StepIndicator extends StatefulWidget {
  final int currentStep;
  final List<String> steps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.steps = const [
      'Geração de Chaves',
      'Preparação',
      'Assinatura',
      'Proteção',
      'Envio',
      'Descriptografia',
    ],
  });

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.low,
        border: Border.all(
          color: AppColors.grey100,
          width: 1,
        ),
      ),
      constraints: const BoxConstraints(
        minWidth: 600,
        maxWidth: 800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            widget.steps.length,
            (index) => _buildStep(index),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Progresso',
          style: AppTypography.h2.copyWith(
            color: AppColors.grey900,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Expanded(
            child: Text(
              '${widget.currentStep}/${widget.steps.length}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int index) {
    final isCompleted = widget.currentStep > index;
    final isCurrent = widget.currentStep == index + 1;
    final isLast = index == widget.steps.length - 1;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _getStepOpacity(index),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                _buildStepCircle(index, isCompleted, isCurrent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStepContent(index, isCompleted, isCurrent),
                ),
              ],
            ),
          ),
          if (!isLast) _buildConnectingLine(index, isCompleted),
        ],
      ),
    );
  }

  Widget _buildStepContent(int index, bool isCompleted, bool isCurrent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.steps[index],
              style: AppTypography.bodyLarge.copyWith(
                color: _getTextColor(isCompleted, isCurrent),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle(int index, bool isCompleted, bool isCurrent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getCircleColor(isCompleted, isCurrent),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
        border: Border.all(
          color:
              isCompleted || isCurrent ? Colors.transparent : AppColors.grey300,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              : Text(
                  '${index + 1}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isCurrent ? Colors.white : AppColors.grey500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildConnectingLine(int index, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 30,
        width: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isCompleted ? AppColors.success : AppColors.grey300,
              _getLineEndColor(index),
            ],
          ),
        ),
      ),
    );
  }

  double _getStepOpacity(int index) {
    if (widget.currentStep > index + 1) return 0.6;
    if (widget.currentStep < index) return 0.6;
    return 1.0;
  }

  Color _getCircleColor(bool isCompleted, bool isCurrent) {
    if (isCompleted) return AppColors.success;
    if (isCurrent) return AppColors.primary;
    return Colors.white;
  }

  Color _getTextColor(bool isCompleted, bool isCurrent) {
    if (isCompleted) return AppColors.success;
    if (isCurrent) return AppColors.primary;
    return AppColors.grey500;
  }

  Color _getLineEndColor(int index) {
    final nextStepCompleted = widget.currentStep > index + 1;
    if (nextStepCompleted) return AppColors.success;
    return AppColors.grey300;
  }
}
