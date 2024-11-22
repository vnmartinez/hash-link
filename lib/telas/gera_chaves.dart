import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import '../widgets/page_header.dart';

class GeraChaves extends StatefulWidget {
  const GeraChaves({super.key});

  @override
  State<GeraChaves> createState() => _GeraChavesState();
}

class _GeraChavesState extends State<GeraChaves> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: StepIndicator(currentStep: 1),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.key),
                    label: const Text('Gerar par de chaves RSA'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.lock),
                    label: const Text('Gerar chave simétrica AES'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Próximo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
