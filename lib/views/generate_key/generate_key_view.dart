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

class GenerateKeyView extends StatelessWidget {
  const GenerateKeyView({super.key});

  ({
    int step,
    Widget widget,
    bool hasPrevious,
    bool hasNext,
  }) _subviewConfiguration(GenerateKeyState state) {
    return switch (state) {
      KeyGeneration() => (
          step: 1,
          widget: const KeyGenerationSubview(),
          hasPrevious: false,
          hasNext: true,
        ),
      Preparation() => (
          step: 2,
          widget: const PreparationSubview(),
          hasPrevious: true,
          hasNext: true,
        ),
      Signature() => (
          step: 3,
          widget: const SignatureSubview(),
          hasPrevious: true,
          hasNext: true,
        ),
      Protection() => (
          step: 4,
          widget: const ProtectionSubview(),
          hasPrevious: true,
          hasNext: true,
        ),
      Shipping() => (
          step: 5,
          widget: const ShippingSubview(),
          hasPrevious: true,
          hasNext: true,
        ),
      Decryption() => (
          step: 6,
          widget: const DecryptionSubview(),
          hasPrevious: true,
          hasNext: false,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
      buildWhen: (previous, current) {
        return _subviewConfiguration(previous).step !=
            _subviewConfiguration(current).step;
      },
      builder: (context, state) {
        final configuration = _subviewConfiguration(state);
        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 250,
                child: StepIndicator(currentStep: configuration.step),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(),
                      const SizedBox(height: 48),
                      Expanded(child: configuration.widget),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (configuration.hasPrevious)
                            ElevatedButton(
                              onPressed: () => context
                                  .read<GenerateKeyBloc>()
                                  .add(const PreviousStep()),
                              child: const Text('Voltar'),
                            )
                          else
                            Container(),
                          if (configuration.hasNext)
                            ElevatedButton(
                              onPressed: () => context
                                  .read<GenerateKeyBloc>()
                                  .add(const NextStep()),
                              child: const Text('Próximo'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
