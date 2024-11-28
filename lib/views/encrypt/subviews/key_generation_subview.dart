import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import 'package:hash_link/widgets/section_title.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import 'package:hash_link/helpers/key_download_helper.dart';
import '../../../widgets/custom_info_tooltip.dart';
import '../../../widgets/custom_toast.dart';
import '../../../widgets/educational_widgets.dart';
import '../encrypt_view.dart';

class KeyGenerationSubview extends StatelessWidget {
  static const Map<String, Map<String, dynamic>> rsaDetailedInfo = {
    'O que é?': {
      'content': '''
      RSA é um dos algoritmos de criptografia assimétrica mais utilizados no mundo. 
      Criado em 1977 por Ron Rivest, Adi Shamir e Leonard Adleman.
      ''',
      'icon': Icons.info_outline,
      'examples': [
        'Como enviar uma carta secreta para alguém',
        'Como assinar digitalmente um documento',
      ],
    },
    'Como funciona?': {
      'content': '''
      • Utiliza dois números primos muito grandes para gerar as chaves
      • A chave pública é usada para cifrar mensagens
      • A chave privada é usada para decifrar mensagens
      • A segurança se baseia na dificuldade de fatorar números grandes
      ''',
      'icon': Icons.settings,
      'animation': 'assets/animations/rsa_process.gif',
      'steps': [
        'Geração das chaves',
        'Cifragem com chave pública',
        'Decifragem com chave privada',
      ],
    },
    'Analogia': {
      'content': '''
      Imagine um cadeado que pode ser fechado por qualquer pessoa (chave pública), mas só pode ser aberto pelo dono da chave (chave privada).
      ''',
      'icon': Icons.lightbulb_outline,
    },
    'Curiosidades': {
      'content': '''
      • É usado por grandes empresas como Google, Amazon e bancos
      • O recorde de quebra do RSA é de 829 bits (2020)
      • Quanto maior a chave, mais seguro, mas mais lento
      • É usado em certificados digitais HTTPS
      ''',
      'icon': Icons.psychology,
    },
    'Aplicações Práticas': {
      'content': '''
      • Assinatura digital de documentos
      • Proteção de e-mails (PGP)
      • Autenticação em sistemas
      • Certificados SSL/TLS
      ''',
      'icon': Icons.work,
    },
    'Limitações': {
      'content': '''
      • Processo de cifragem lento para grandes volumes
      • Requer gerenciamento seguro das chaves
      • Vulnerável a ataques quânticos no futuro
      • Tamanho das chaves cresce com o tempo
      ''',
      'icon': Icons.warning_amber,
    },
  };

  static const Map<String, Map<String, dynamic>> aesDetailedInfo = {
    'O que é?': {
      'content': '''
      AES (Advanced Encryption Standard) é o padrão global para criptografia simétrica.
      Também conhecido como Rijndael, foi selecionado pelo NIST em 2001.
      ''',
      'icon': Icons.info_outline,
    },
    'Como funciona?': {
      'content': '''
      • Usa a mesma chave para cifrar e decifrar
      • Opera em blocos de dados de tamanho fixo
      • Aplica múltiplas rodadas de transformações
      • Suporta chaves de 128, 192 ou 256 bits
      ''',
      'icon': Icons.settings,
    },
    'Quando usar?': {
      'content': '''
      • Cifragem de grandes volumes de dados
      • Proteção de arquivos e comunicações
      • Sistemas que exigem alto desempenho
      • Comunicações em tempo real
      ''',
      'icon': Icons.schedule,
    },
    'Cuidados importantes': {
      'content': '''
      • Proteja a distribuição da chave
      • Use um modo de operação seguro (GCM, CBC)
      • Nunca reutilize combinações de chave/IV
      • Implemente rotação periódica de chaves
      ''',
      'icon': Icons.warning,
    },
    'Curiosidades': {
      'content': '''
      • Foi escolhido após 5 anos de testes e análises
      • É resistente a ataques quânticos conhecidos
      • Usado pela NSA para documentos top-secret
      • Processa dados 6x mais rápido que o DES
      ''',
      'icon': Icons.psychology,
    },
    'Comparação com outros': {
      'content': '''
      • Mais seguro que DES e 3DES
      • Mais rápido que Blowfish
      • Menor consumo de memória que RC6
      • Mais fácil de implementar que Twofish
      ''',
      'icon': Icons.compare_arrows,
    },
    'Aplicações Práticas': {
      'content': '''
      • Criptografia de discos rígidos
      • Proteção de redes Wi-Fi (WPA2/3)
      • VPNs e túneis seguros
      • Armazenamento em nuvem
      ''',
      'icon': Icons.work,
    },
  };

  const KeyGenerationSubview({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    GenerateKeyView.showToast(
      context,
      'Copiado para a área de transferência',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 900;

        return ListView(
          padding: EdgeInsets.only(
            left: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
            right: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
            bottom: isSmallScreen ? AppSpacing.md : AppSpacing.lg,
          ),
          children: [
            Stack(
              children: [
                SectionTitle(
                  title: 'Geração de Chaves',
                  subtitle:
                      'Gere as chaves necessárias para o processo de criptografia',
                  titleStyle: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: isSmallScreen ? 20 : 24,
                  ),
                  subtitleStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: CustomInfoTooltip(
                    maxWidth: 300,
                    message: '''
Configurações atuais de geração:

RSA (pointycastle):
• Tamanho da chave: 2048 bits
• Expoente público: 65537
• Iterações de teste: 12
• Algoritmo de hash: SHA-256
• Formato: PEM (PKCS#1)
• Biblioteca: PointyCastle
• Gerador aleatório: Fortuna

AES (pointycastle):
• Tamanho da chave: 256 bits (32 bytes)
• Modo de operação: CBC
• Padding: PKCS7
• IV: 16 bytes aleatórios
• Biblioteca: PointyCastle
• Gerador aleatório: Fortuna

Segurança:
• Seed aleatório: DateTime.microsecond
• Assinatura: SHA-256/RSA
• Verificação: RSA/PSS
• Chaves exportadas em Base64

Compatibilidade:
• OpenSSL
• PEM format
• PKCS standards
''',
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? AppSpacing.lg : AppSpacing.xl),
            if (isMediumScreen)
              Column(
                children: [
                  _buildRSACard(context, theme, isSmallScreen),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAESCard(context, theme, isSmallScreen),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRSACard(context, theme, isSmallScreen)),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: _buildAESCard(context, theme, isSmallScreen)),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildRSACard(
      BuildContext context, ThemeData theme, bool isSmallScreen) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.key, color: AppColors.primary),
                SizedBox(width: isSmallScreen ? AppSpacing.sm : AppSpacing.md),
                Expanded(
                  child: Text(
                    'Par de Chaves RSA',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                    ),
                  ),
                ),
                const CustomInfoTooltip(
                  maxWidth: 400,
                  message: '''
Processo de Geração RSA:

1. Escolha de Primos (p, q):
   • Gera números primos grandes (1024 bits cada)
   • Usa teste de Miller-Rabin para primalidade
   • p e q devem ser diferentes e seguros

2. Cálculo do Módulo (n):
   • n = p × q
   • Tamanho final: 2048 bits

3. Cálculo do Totiente (φ(n)):
   • φ(n) = (p-1) × (q-1)

4. Escolha do Expoente Público (e):
   • e = 65537 (0x10001)
   • Primo de Fermat para eficiência
   • Deve ser coprimo com φ(n)

5. Cálculo do Expoente Privado (d):
   • d = e⁻¹ mod φ(n)
   • Usa algoritmo estendido de Euclides

6. Verificações de Segurança:
   • Teste de consistência: e×d ≡ 1 (mod φ(n))
   • Verificação de tamanho das chaves
   • Teste de cifragem/decifragem

7. Formatação PEM:
   • Codificação ASN.1 DER
   • Envelope PEM com cabeçalho/rodapé
   • Base64 com quebras de linha

Chave Pública: (e, n)
Chave Privada: (d, n)

Operações:
• Cifragem: c = m^e mod n
• Decifragem: m = c^d mod n
''',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Gere um par de chaves RSA para garantir a segurança da comunicação',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<GenerateKeyBloc>()
                            .add(const GenerateRSAKeyPair());
                        GenerateKeyView.showToast(
                          context,
                          'Par de chaves RSA gerado com sucesso!',
                          type: ToastType.success,
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.vpn_key),
                          SizedBox(width: AppSpacing.md),
                          Text(
                            'Gerar par de chaves RSA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state is KeyGeneration &&
                        (state.publicKey != null || state.privateKey != null))
                      Container(
                        margin: const EdgeInsets.only(top: AppSpacing.md),
                        child: Column(
                          children: [
                            if (state.publicKey != null)
                              _KeyCard(
                                title: 'Chave Pública',
                                content: state.publicKey!,
                                onCopy: () =>
                                    _copyToClipboard(context, state.publicKey!),
                                onDownload: () =>
                                    KeyDownloadHelper.downloadPublicKey(
                                        state.publicKey!),
                              ),
                            const SizedBox(height: AppSpacing.md),
                            if (state.privateKey != null)
                              _KeyCard(
                                title: 'Chave Privada',
                                content: state.privateKey!,
                                onCopy: () => _copyToClipboard(
                                    context, state.privateKey!),
                                onDownload: () =>
                                    KeyDownloadHelper.downloadPrivateKey(
                                        state.privateKey!),
                                isPrivate: true,
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            const EnhancedEducationalSection(
              title: 'Aprenda sobre RSA',
              sections: rsaDetailedInfo,
              icon: Icons.school,
              initiallyExpanded: false,
            ),
            const SecurityTips(
              tips: [
                'Mantenha sua chave privada em local seguro',
                'Compartilhe apenas a chave pública',
                'Use chaves de no mínimo 2048 bits',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAESCard(
      BuildContext context, ThemeData theme, bool isSmallScreen) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock, color: AppColors.primary),
                SizedBox(width: isSmallScreen ? AppSpacing.sm : AppSpacing.md),
                Expanded(
                  child: Text(
                    'Chave Simétrica AES',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                    ),
                  ),
                ),
                const CustomInfoTooltip(
                  maxWidth: 400,
                  message: '''
Processo de Geração e Operação AES-256:

1. Geração da Chave:
   • 256 bits (32 bytes) aleatórios
   • Usa gerador Fortuna CSPRNG
   • Entropia do sistema operacional

2. Expansão da Chave (Key Schedule):
   • 14 rodadas para AES-256
   • 15 chaves de rodada de 128 bits
   • Usa S-box e rotações

3. Processo de Cifragem:
   • Divisão em blocos de 128 bits
   • Estado inicial: XOR com chave
   • Por rodada:
     - SubBytes (substituição não-linear)
     - ShiftRows (permutação)
     - MixColumns (mistura linear)
     - AddRoundKey (XOR com chave da rodada)

4. Modo CBC:
   • IV aleatório de 16 bytes
   • Encadeamento de blocos
   • XOR com bloco anterior

5. Padding PKCS7:
   • Completa último bloco
   • Valor = bytes faltantes

6. Formato Final:
   • IV (16 bytes)
   • Dados cifrados
   • Padding PKCS7

Matemática da Cifragem:
• Campo finito GF(2⁸)
• Polinômio irredutível: x⁸ + x⁴ + x³ + x + 1
• Multiplicação matricial em GF(2⁸)
''',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Gere uma chave simétrica AES para cifrar os arquivos',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<GenerateKeyBloc, GenerateKeyState>(
              builder: (context, state) {
                final canGenerate =
                    state is KeyGeneration && state.canGenerateSymmetricKey;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canGenerate ? AppColors.primary : AppColors.grey300,
                        foregroundColor:
                            canGenerate ? Colors.white : AppColors.grey500,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: canGenerate
                          ? () {
                              context
                                  .read<GenerateKeyBloc>()
                                  .add(const GenerateAESSymmetricKey());
                              GenerateKeyView.showToast(
                                context,
                                'Chave AES gerada com sucesso!',
                                type: ToastType.success,
                              );
                            }
                          : null,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock),
                          SizedBox(width: AppSpacing.md),
                          Text(
                            'Gerar chave simétrica AES',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state is KeyGeneration && state.symmetricKey != null)
                      Container(
                        margin: const EdgeInsets.only(top: AppSpacing.md),
                        child: _KeyCard(
                          title: 'Chave AES',
                          content: state.symmetricKey!,
                          onCopy: () =>
                              _copyToClipboard(context, state.symmetricKey!),
                          onDownload: () =>
                              KeyDownloadHelper.downloadSymmetricKey(
                                  state.symmetricKey!),
                        ),
                      ),
                  ],
                );
              },
            ),
            const EnhancedEducationalSection(
              title: 'Aprenda sobre AES',
              sections: aesDetailedInfo,
              icon: Icons.school,
              initiallyExpanded: false,
            ),
            const SecurityTips(
              tips: [
                'Proteja a distribuição da chave',
                'Use um modo de operação seguro (GCM, CBC)',
                'Nunca reutilize combinações de chave/IV',
                'Implemente rotação periódica de chaves',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyCard extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onCopy;
  final VoidCallback onDownload;
  final bool isPrivate;

  const _KeyCard({
    required this.title,
    required this.content,
    required this.onCopy,
    required this.onDownload,
    this.isPrivate = false,
  });

  @override
  State<_KeyCard> createState() => _KeyCardState();
}

class _KeyCardState extends State<_KeyCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 1,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? AppSpacing.sm : AppSpacing.md,
              vertical: isSmallScreen ? AppSpacing.xs : AppSpacing.sm,
            ),
            leading: Icon(
              widget.isPrivate ? Icons.security : Icons.key,
              color: AppColors.primary,
              size: isSmallScreen ? 20 : 24,
            ),
            title: Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            trailing:
                isSmallScreen ? _buildCompactActions() : _buildFullActions(),
          ),
          if (_isExpanded)
            Container(
              margin:
                  EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.md),
              padding:
                  EdgeInsets.all(isSmallScreen ? AppSpacing.sm : AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: SelectableText(
                widget.content,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactActions() {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, color: AppColors.grey700),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('Copiar'),
            ],
          ),
          onTap: () => widget.onCopy(),
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.download, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('Baixar'),
            ],
          ),
          onTap: () => widget.onDownload(),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(_isExpanded ? Icons.visibility_off : Icons.visibility,
                  size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(_isExpanded ? 'Ocultar' : 'Mostrar'),
            ],
          ),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
      ],
    );
  }

  Widget _buildFullActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: widget.onCopy,
          tooltip: 'Copiar chave',
        ),
        IconButton(
          icon: const Icon(Icons.download, size: 20),
          onPressed: widget.onDownload,
          tooltip: 'Baixar chave',
        ),
        IconButton(
          icon: Icon(
            _isExpanded ? Icons.visibility_off : Icons.visibility,
            size: 20,
          ),
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          tooltip: _isExpanded ? 'Ocultar chave' : 'Mostrar chave',
        ),
      ],
    );
  }
}
