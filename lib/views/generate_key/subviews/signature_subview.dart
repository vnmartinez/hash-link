import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';

class SignatureSubview extends StatelessWidget {
  const SignatureSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Processo de Assinatura e Cifragem',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nesta etapa, o arquivo será assinado digitalmente e depois cifrado para garantir autenticidade e confiabilidade.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'O processo ocorre em duas etapas:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Criação da assinatura digital usando sua chave privada RSA',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Cifragem do arquivo usando a chave simétrica AES',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton.icon(
            onPressed: () =>
                context.read<GenerateKeyBloc>().add(const SignAndEncryptFile()),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar Processo'),
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
            if (state is! Signature) return Container();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.fileSignature != null)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Assinatura'),
                        Text(state.fileSignature!),
                      ],
                    ),
                  ),
                const SizedBox(width: 30),
                if (state.fileSignature != null)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Cifragem'),
                        Text(state.fileEncryption!),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
