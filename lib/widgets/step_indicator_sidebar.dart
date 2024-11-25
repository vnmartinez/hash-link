import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class StepIndicator extends StatefulWidget {
  final int currentStep;
  final List<String> steps;

  static const Map<String, String> stepDescriptions = {
    'Geração de Chaves':
        'Crie suas chaves RSA e AES para garantir a segurança da comunicação',
    'Preparação': 'Configure o ambiente e selecione o arquivo a ser protegido',
    'Assinatura':
        'Assine digitalmente o arquivo para garantir sua autenticidade',
    'Proteção': 'Proteja a chave simétrica usando criptografia assimétrica',
    'Envio': 'Prepare e envie o pacote criptografado',
  };

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.steps = const [
      'Geração de Chaves',
      'Preparação',
      'Assinatura',
      'Proteção',
      'Envio',
    ],
  });

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(AppSpacing.containerSm),
          padding: const EdgeInsets.all(AppSpacing.containerSm),
          constraints: const BoxConstraints(
            minWidth: 600,
            maxWidth: 800,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(
                widget.steps.length,
                (index) => _buildStep(index, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          'Progresso',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            '${widget.currentStep}/${widget.steps.length}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int index, ThemeData theme) {
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
                _buildStepCircle(index, isCompleted, isCurrent, theme),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child:
                      _buildStepContent(index, isCompleted, isCurrent, theme),
                ),
              ],
            ),
          ),
          if (!isLast) _buildConnectingLine(index, isCompleted, theme),
        ],
      ),
    );
  }

  Widget _buildStepContent(
      int index, bool isCompleted, bool isCurrent, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                widget.steps[index],
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _getTextColor(isCompleted, isCurrent, theme),
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
        ),
        if (isCurrent)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              StepIndicator.stepDescriptions[widget.steps[index]] ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
      ],
    );
  }

  Widget _buildStepCircle(
      int index, bool isCompleted, bool isCurrent, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getCircleColor(isCompleted, isCurrent, theme),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
        border: Border.all(
          color: isCompleted || isCurrent
              ? Colors.transparent
              : theme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimary,
                  size: 16,
                )
              : Text(
                  '${index + 1}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isCurrent
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildConnectingLine(int index, bool isCompleted, ThemeData theme) {
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
              isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              _getLineEndColor(index, theme),
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

  Color _getCircleColor(bool isCompleted, bool isCurrent, ThemeData theme) {
    if (isCompleted) return theme.colorScheme.primary;
    if (isCurrent) return theme.colorScheme.primary;
    return theme.colorScheme.surface;
  }

  Color _getTextColor(bool isCompleted, bool isCurrent, ThemeData theme) {
    if (isCompleted) return theme.colorScheme.primary;
    if (isCurrent) return theme.colorScheme.primary;
    return theme.colorScheme.onSurfaceVariant;
  }

  Color _getLineEndColor(int index, ThemeData theme) {
    final nextStepCompleted = widget.currentStep > index + 1;
    if (nextStepCompleted) return theme.colorScheme.primary;
    return theme.colorScheme.outline;
  }
}
