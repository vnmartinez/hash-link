import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import 'package:hash_link/views/encrypt/subviews/key_generation_subview.dart';
import 'package:hash_link/views/encrypt/subviews/preparation_subview.dart';
import 'package:hash_link/views/encrypt/subviews/protection_subview.dart';
import 'package:hash_link/views/encrypt/subviews/shipping_subview.dart';
import 'package:hash_link/views/encrypt/subviews/signature_subview.dart';
import 'package:hash_link/widgets/page_header.dart';
import 'package:hash_link/widgets/step_indicator_sidebar.dart';
import 'package:hash_link/widgets/action_buttons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/custom_toast.dart';
import '../initial/initial_view.dart';

class GenerateKeyView extends StatefulWidget {
  const GenerateKeyView({super.key});

  static const route = '/generate-key';

  static void showToast(BuildContext context, String message,
      {ToastType type = ToastType.info}) {
    CustomToast.show(context, message, type: type);
  }

  @override
  State<GenerateKeyView> createState() => _GenerateKeyViewState();
}

class _GenerateKeyViewState extends State<GenerateKeyView> {
  @override
  void initState() {
    super.initState();
    context.read<GenerateKeyBloc>().add(const ResetGenerateKey());
  }

  ({
    int step,
    Widget widget,
    bool hasPrevious,
    bool hasNext,
    bool canNext,
  }) _subviewConfiguration(GenerateKeyState state) {
    return switch (state) {
      KeyGeneration() => (
          step: 1,
          widget: const KeyGenerationSubview(),
          hasPrevious: false,
          hasNext: true,
          canNext: state.isValid,
        ),
      Preparation() => (
          step: 2,
          widget: const PreparationSubview(),
          hasPrevious: true,
          hasNext: true,
          canNext: state.isValid,
        ),
      Signature() => (
          step: 3,
          widget: const SignatureSubview(),
          hasPrevious: true,
          hasNext: true,
          canNext: state.isValid,
        ),
      Protection() => (
          step: 4,
          widget: const ProtectionSubview(),
          hasPrevious: true,
          hasNext: true,
          canNext: state.isValid,
        ),
      Shipping() => (
          step: 5,
          widget: const ShippingSubview(),
          hasPrevious: true,
          hasNext: true,
          canNext: state.isValid,
        ),
      _ => (
          step: 1,
          widget: const KeyGenerationSubview(),
          hasPrevious: false,
          hasNext: true,
          canNext: false,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      buildWhen: (previous, current) {
        final prevConfig = _subviewConfiguration(previous);
        final currentConfig = _subviewConfiguration(current);
        return prevConfig.canNext != currentConfig.canNext ||
            prevConfig.hasPrevious != currentConfig.hasPrevious ||
            previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        final configuration = _subviewConfiguration(state);

        void handleNextStep() {
          if (state is Decryption) {
            context.read<GenerateKeyBloc>().add(RestartProcess());
          } else {
            context.read<GenerateKeyBloc>().add(const NextStep());
          }
        }

        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 330,
                child: Column(
                  children: [
                    Expanded(
                      child: StepIndicator(currentStep: configuration.step),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerLow
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed(InitialView.route),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                                horizontal: AppSpacing.lg,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Voltar ao Menu',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.lg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 185),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: configuration.widget),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: BlocBuilder<GenerateKeyBloc,
                                      GenerateKeyState>(
                                    buildWhen: (previous, current) {
                                      final prevConfig =
                                          _subviewConfiguration(previous);
                                      final currentConfig =
                                          _subviewConfiguration(current);
                                      return prevConfig.canNext !=
                                              currentConfig.canNext ||
                                          prevConfig.hasPrevious !=
                                              currentConfig.hasPrevious ||
                                          previous.runtimeType !=
                                              current.runtimeType;
                                    },
                                    builder: (context, state) {
                                      final configuration =
                                          _subviewConfiguration(state);
                                      return ActionButtons(
                                        onPressedBack: () => context
                                            .read<GenerateKeyBloc>()
                                            .add(const PreviousStep()),
                                        onPressedNext: handleNextStep,
                                        nextLabel: state is Shipping
                                            ? 'Reiniciar processo'
                                            : 'Próximo',
                                        showBackButton:
                                            configuration.hasPrevious,
                                        showNextButton: true,
                                        enableNextButton: configuration.canNext,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: AppSpacing.lg,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      child: PageHeader(
                        logoPath: 'assets/images/logo.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
