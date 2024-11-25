import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/views/generate_key/subviews/decryption_subview.dart';
import 'package:hash_link/views/generate_key/subviews/key_generation_subview.dart';
import 'package:hash_link/views/generate_key/subviews/preparation_subview.dart';
import 'package:hash_link/views/generate_key/subviews/protection_subview.dart';
import 'package:hash_link/views/generate_key/subviews/shipping_subview.dart';
import 'package:hash_link/views/generate_key/subviews/signature_subview.dart';
import 'package:hash_link/widgets/page_header.dart';
import 'package:hash_link/widgets/step_indicator.dart';
import 'package:hash_link/widgets/action_buttons.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/custom_toast.dart';

class GenerateKeyView extends StatelessWidget {
  const GenerateKeyView({super.key});

  static void showToast(BuildContext context, String message,
      {ToastType type = ToastType.info}) {
    CustomToast.show(context, message, type: type);
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
      Decryption() => (
          step: 6,
          widget: const DecryptionSubview(),
          hasPrevious: true,
          hasNext: false,
          canNext: true,
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
                child: StepIndicator(currentStep: configuration.step),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.lg,
                        right: AppSpacing.lg,
                        left: AppSpacing.lg,
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
                                        nextLabel: state is Decryption
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
