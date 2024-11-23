import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/widgets/section_title.dart';

class KeyGenerationSubview extends StatelessWidget {
  const KeyGenerationSubview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        const SectionTitle(
          title: 'Geração de Chaves',
          subtitle:
              'Gere as chaves necessárias para o processo de criptografia',
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Par de Chaves RSA',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gere um par de chaves RSA para garantir a segurança da comunicação',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context
                      .read<GenerateKeyBloc>()
                      .add(const GenerateRSAKeyPair()),
                  icon: const Icon(Icons.key),
                  label: const Text('Gerar par de chaves RSA'),
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chave Simétrica AES',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gere uma chave simétrica AES para cifrar os arquivos',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
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
                    );
                  },
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
            ),
          ),
        ),
      ],
    );
  }
}
