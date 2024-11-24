import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';

class ShippingSubview extends StatelessWidget {
  const ShippingSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Empacotamento e envio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Nesta etapa, todos os elementos processados são combinados em um único pacote seguro para envio. O pacote contém o arquivo cifrado, a assinatura digital e a chave simétrica protegida.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                  'Componentes do pacote:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Arquivo cifrado com chave simétrica',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Assinatura digital do arquivo original',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Chave simétrica cifrada com RSA',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.read<GenerateKeyBloc>().add(const SendPackage()),
              icon: const Icon(Icons.send),
              label: const Text('Enviar Pacote'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParticipante(
                Icons.person,
                'Aluno',
                'Remetente',
                true,
              ),
              _buildArrow(),
              _buildParticipante(
                Icons.person_outline,
                'Professor',
                'Destinatário',
                false,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                  'O pacote é enviado de forma segura, garantindo:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Confidencialidade (através da cifragem)',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Autenticidade (através de assinatura digital)',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Integridade (através do hash)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipante(
      IconData icon, String titulo, String subtitulo, bool isActive) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(
              color: isActive ? Colors.blue : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: TextStyle(
              color: isActive ? Colors.blue : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Icon(
        Icons.arrow_forward,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}
