import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/helpers/file_reader_helper.dart';

class PreparationSubview extends StatelessWidget {
  const PreparationSubview({super.key});

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
        BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            final file =
                state is Preparation ? state.teacherPublicKeyFile : null;
            final selecting =
                state is Preparation && state.selectingTeacherPublicKeyFile;

            return _buildSecao(
              'Importar chave pública do professor',
              file?.name ?? 'Nenhum arquivo selecionado',
              selecting
                  ? null
                  : () => context
                      .read<GenerateKeyBloc>()
                      .add(const SelectTeacherPublicKeyFile()),
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
          builder: (context, state) {
            final file = state is Preparation ? state.fileToSend : null;
            final selecting = state is Preparation && state.selectingFileToSend;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSecao(
                  'Selecionar arquivo para envio',
                  file?.name ?? 'Nenhum arquivo selecionado',
                  selecting
                      ? null
                      : () => context
                          .read<GenerateKeyBloc>()
                          .add(const SelectFileToSend()),
                ),
                if (file != null) ...[
                  const SizedBox(height: 24),
                  _buildInformacoesArquivo(file),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSecao(
      String titulo, String nomeArquivo, VoidCallback? onPressedEscolher) {
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

  Widget _buildInformacoesArquivo(FileReader file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações do arquivo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text('Nome: ${file.name}'),
        Text('Tamanho: ${file.size}'),
        Text('Hash SHA-256: ${file.hash}'),
      ],
    );
  }
}
