import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';

class KeyGenerationSubview extends StatelessWidget {
  const KeyGenerationSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: () =>
                context.read<GenerateKeyBloc>().add(const GenerateRSAKeyPair()),
            icon: const Icon(Icons.key),
            label: const Text('Gerar par de chaves RSA'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ),
        BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            if (state is! KeyGeneration) return Container();
            return Column(
              children: [
                if (state.publicKey != null) Text(state.publicKey!),
                if (state.privateKey != null) Text(state.privateKey!),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
            builder: (context, state) {
              final canGenerate =
                  state is KeyGeneration && state.canGenerateSymmetricKey;
              return ElevatedButton.icon(
                onPressed: canGenerate
                    ? () => context
                        .read<GenerateKeyBloc>()
                        .add(const GenerateAESSymmetricKey())
                    : null,
                icon: const Icon(Icons.lock),
                label: const Text('Gerar chave simétrica AES'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              );
            },
          ),
        ),
        BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            if (state is! KeyGeneration) return Container();
            return Column(
              children: [
                if (state.symmetricKey != null)
                  Text(state.symmetricKey!.join(' ')),
              ],
            );
          },
        ),
      ],
    );
  }
}
