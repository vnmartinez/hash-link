import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart' as crypto;

class PreparationSubview extends StatefulWidget {
  const PreparationSubview({super.key});

  @override
  State<PreparationSubview> createState() => _PreparationSubviewState();
}

class _PreparationSubviewState extends State<PreparationSubview> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preparação de ambiente',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildSecao(
          'Importar chave pública do professor',
          chavePublica?.path.split('/').last ?? 'Nenhum arquivo selecionado',
          selecionarChavePublica,
        ),
        const SizedBox(height: 24),
        _buildSecao(
          'Selecionar arquivo para envio',
          arquivoEnvio?.path.split('/').last ?? 'Nenhum arquivo selecionado',
          selecionarArquivo,
        ),
        if (arquivoEnvio != null) ...[
          const SizedBox(height: 24),
          _buildInformacoesArquivo(),
        ],
      ],
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
    return Expanded(
      child: Column(
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
      ),
    );
  }
}
