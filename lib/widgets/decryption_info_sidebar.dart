import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_info_tooltip.dart';

class DecryptionInfoSidebar extends StatelessWidget {
  const DecryptionInfoSidebar({super.key});

  static const List<Map<String, String>> decryptionSteps = [
    {
      'title': 'Importação da Chave Privada',
      'subtitle': 'Carregamento da chave RSA para iniciar o processo',
      'description':
          'A chave privada RSA é a parte secreta do par de chaves criptográficas. Ela contém números primos grandes que permitem reverter a operação matemática realizada durante a criptografia. Apenas o proprietário desta chave pode realizar a descriptografia.',
    },
    {
      'title': 'Verificação da Assinatura',
      'subtitle': 'Confirmação da autenticidade do arquivo',
      'description':
          'A assinatura digital é um hash criptografado do arquivo original. Usando a chave pública do remetente, o sistema verifica se o hash descriptografado corresponde ao hash do arquivo recebido, confirmando que o arquivo não foi alterado e realmente veio do remetente esperado.',
    },
    {
      'title': 'Recuperação da Chave AES',
      'subtitle': 'Obtenção da chave simétrica de descriptografia',
      'description':
          'A chave AES (Advanced Encryption Standard) foi protegida com a chave pública RSA durante a criptografia. Agora, usando a chave privada RSA, é possível recuperar a chave AES original. Este processo combina a segurança do RSA com a eficiência do AES.',
    },
    {
      'title': 'Descriptografia do Conteúdo',
      'subtitle': 'Transformação final do conteúdo cifrado',
      'description':
          'Com a chave AES recuperada, o sistema utiliza o algoritmo AES em modo CBC (Cipher Block Chaining) para descriptografar o arquivo. O AES trabalha em blocos de 128 bits, transformando o texto cifrado de volta ao conteúdo original através de operações matemáticas reversíveis.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Processo de Descriptografia',
              style: AppTypography.h4.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Entenda como funciona o processo de descriptografia segura:',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...decryptionSteps.map((step) => _buildInfoStep(step)),
            const SizedBox(height: AppSpacing.containerSm),
            _buildSecurityNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStep(Map<String, String> step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: const Icon(
              Icons.lock_open,
              size: 14,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        step['title']!,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.grey900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomInfoTooltip(message: step['description']!),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  step['subtitle']!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.security,
                color: AppColors.warning,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Mantenha sua chave privada segura e nunca a compartilhe. Ela é essencial para a descriptografia e não pode ser recuperada se perdida.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
