import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  final steps = const [
    'Geração de Chaves',
    'Preparação',
    'Assinatura',
    'Proteção',
    'Envio',
    'Descriptografia',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          steps.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentStep == index + 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: currentStep == index + 1
                            ? Colors.white
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  steps[index],
                  style: TextStyle(
                    color: currentStep == index + 1
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                    fontWeight: currentStep == index + 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}