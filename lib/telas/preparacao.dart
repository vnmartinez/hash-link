import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart' as crypto;
import '../widgets/step_indicator.dart';
import '../widgets/page_header.dart';
import 'assinatura.dart';

class Preparacao extends StatefulWidget {
  const Preparacao({super.key});

  @override
  State<Preparacao> createState() => _PreparacaoState();
}

class _PreparacaoState extends State<Preparacao> {
  File? chavePublica;
  File? arquivoEnvio;
  String? hashArquivo;

  Future<void> selecionarChavePublica() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        chavePublica = File(result.files.single.path!);
      });
    }
  }

  Future<void> selecionarArquivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final hashFinal = crypto.sha256.convert(bytes).toString();

      setState(() {
        arquivoEnvio = file;
        hashArquivo = hashFinal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: StepIndicator(currentStep: 2),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(),
                  const SizedBox(height: 48),
                  const Text(
                    'Preparação de ambiente',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildSecao(
                    'Importar chave pública do professor',
                    chavePublica?.path.split('/').last ??
                        'Nenhum arquivo selecionado',
                    selecionarChavePublica,
                  ),
                  const SizedBox(height: 24),
                  _buildSecao(
                    'Selecionar arquivo para envio',
                    arquivoEnvio?.path.split('/').last ??
                        'Nenhum arquivo selecionado',
                    selecionarArquivo,
                  ),
                  if (arquivoEnvio != null) ...[
                    const SizedBox(height: 24),
                    _buildInformacoesArquivo(),
                  ],
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Voltar'),
                      ),
                      ElevatedButton(
                        onPressed: arquivoEnvio != null && chavePublica != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Assinatura()),
                                );
                              }
                            : null,
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
  }

  Widget _buildSecao(
      String titulo, String nomeArquivo, VoidCallback onPressedEscolher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPressedEscolher,
              icon: const Icon(Icons.file_upload),
              label: const Text('Escolher arquivo'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                nomeArquivo,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInformacoesArquivo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações do arquivo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text('Nome: ${arquivoEnvio!.path.split('/').last}'),
        Text(
            'Tamanho: ${(arquivoEnvio!.lengthSync() / 1024).toStringAsFixed(2)} KB'),
        Text('Hash SHA-256: $hashArquivo'),
      ],
    );
  }
}
