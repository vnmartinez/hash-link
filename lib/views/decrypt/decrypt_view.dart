import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/decrypt/decrypt_bloc.dart';
import 'package:hash_link/widgets/page_header.dart';

class DecryptView extends StatefulWidget {
  const DecryptView({super.key});

  static const route = '/decrypt';

  @override
  State<DecryptView> createState() => _DecryptViewState();
}

class _DecryptViewState extends State<DecryptView> {

  @override
  void initState() {
    context.read<DecryptBloc>().add(const ResetDecrypt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DecryptBloc, DecryptState>(
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
              const PageHeader(), 
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<DecryptBloc>()
                                  .add(const SelectPrivateKey());
                            },
                            child: const Text('Selecionar Chave Privada'),
                          ),
                          if (state.privateKeyError != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  state.privateKeyError!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          if (state.privateKey != null)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'Chave Privada importada com sucesso!',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<DecryptBloc>()
                                  .add(const SelectPackage());
                            },
                            child: const Text('Selecionar Pacote'),
                          ),
                          Column(
                            children: [
                              if (state.dataEncryptedError != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      state.dataEncryptedError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              if (state.aesKeyError != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      state.aesKeyError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              if (state.signatureError != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      state.signatureError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              if (state.publicKeyError != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      state.publicKeyError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              if (state.dataEncrypted != null)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Dados Encriptados importados com sucesso!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              if (state.aesKey != null)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Chave AES importada com sucesso!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              if (state.signature != null)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Assinatura importada com sucesso!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              if (state.publicKey != null)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Chave Pública importada com sucesso!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: state.inputsIsValid
                      ? () =>
                          context.read<DecryptBloc>().add(const DecryptData())
                      : null,
                  child: const Text('Descriptografar'),
                ),
                if (state.decryptionError != null) Text(state.decryptionError!),
                if (state.decryptedFile != null)
                  Column(
                    children: [
                      const Text(
                        'Arquivo descriptografado com sucesso!',
                        style: TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        state.isSignatureValid
                            ? 'Assinatura do arquivo é válida!'
                            : 'Assinatura do arquivo não é válida!',
                        style: TextStyle(
                          color: state.isSignatureValid
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          state.decryptedFile!.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
