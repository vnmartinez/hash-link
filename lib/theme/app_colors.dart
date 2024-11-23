import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const primary = Color(0xFF00ADB5); // Azul turquesa
  static const secondary = Color(0xFF393E46); // Cinza escuro
  static const accent = Color(0xFF222831); // Cinza mais escuro

  // Estados
  static const success = Color(0xFF34A853); // Verde (mantido)
  static const error = Color(0xFFEA4335); // Vermelho (mantido)
  static const warning = Color(0xFFFBBC04); // Amarelo (mantido)
  static const info = Color(0xFF00ADB5); // Alterado para combinar com primary

  // Tons de cinza
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey700 = Color(0xFF616161);
  static const grey900 = Color(0xFF212121);

  // Background e superfícies
  static const background = Color(0xFFEEEEEE); // Novo fundo cinza claro
  static const surface =
      Color(0xFFEEEEEE); // Alterado para combinar com background
  static const surfaceVariant = Color(0xFF393E46); // Cinza escuro
  static const surfaceDark = Color(0xFF222831); // Cinza mais escuro
}
