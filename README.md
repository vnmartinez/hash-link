# HashLink - Sistema de Criptografia e Assinatura Digital

## 📋 Sobre o Projeto

O HashLink é uma aplicação educacional desenvolvida em Flutter para a disciplina de Segurança de Sistemas da Universidade de Rio Verde. O sistema demonstra conceitos práticos de criptografia, assinatura digital e proteção de dados.

## 🎯 Objetivos Educacionais

- Compreender criptografia simétrica (AES) e assimétrica (RSA)
- Aprender sobre assinatura digital e verificação de integridade
- Entender o processo de proteção e compartilhamento seguro de dados
- Praticar conceitos de segurança da informação

## 🔑 Funcionalidades Principais

### 1. Geração de Chaves
- Geração de par de chaves RSA (pública/privada)
- Geração de chave simétrica AES
- Exportação segura das chaves

### 2. Assinatura Digital
- Seleção de arquivos para assinatura
- Geração de hash do documento
- Assinatura usando chave privada RSA
- Verificação da assinatura

### 3. Proteção de Dados
- Cifragem de arquivos com AES
- Proteção da chave simétrica com RSA
- Empacotamento seguro dos dados

### 4. Verificação e Descriptografia
- Importação de chaves
- Verificação de assinaturas
- Recuperação de dados originais

## 🛠️ Tecnologias Utilizadas

- Flutter/Dart
- Bibliotecas de criptografia
- Gerenciamento de estado com BLoC
- Interface responsiva

## 📚 Conceitos Abordados

- Criptografia RSA
- Criptografia AES
- Assinatura Digital

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado
- Editor de código (VS Code, Android Studio)
- Git

### Clone o repositório
	git clone https://github.com/vnmartinez/hash-link.git

### Instale as dependências
    flutter pub get 

### Execute o projeto
    flutter run

## 👥 Fluxo de Uso

### Aluno (Remetente)
- Gera par de chaves RSA
- Seleciona arquivo para envio
- Assina digitalmente o arquivo
- Protege com criptografia
- Envia ao professor

### Professor (Destinatário)
- Recebe o pacote protegido
- Usa chave privada para descriptografar
Verifica a assinatura digital
- Acessa o conteúdo original

## 🔒 Boas Práticas de Segurança
- Nunca compartilhe chaves privadas
- Use chaves RSA de no mínimo 2048 bits
- Proteja o armazenamento das chaves
- Verifique sempre a integridade dos arquivos
- Implemente rotação periódica de chaves

## 📖 Material Complementar
O projeto inclui seções educacionais interativas que explicam:
- Fundamentos de criptografia
- Diferenças entre criptografia simétrica e assimétrica
- Processo de assinatura digital
- Proteção e transmissão segura de dados

## 🤝 Contribuições
Contribuições são bem-vindas! Para contribuir:
- Faça um fork do projeto
- Crie uma branch para sua feature
- Commit suas mudanças
- Push para a branch
- Abra um Pull Request
---
Desenvolvido para fins educacionais na disciplina de Segurança de Sistemas - UniRV 🎓
