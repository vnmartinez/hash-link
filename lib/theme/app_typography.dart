import 'package:flutter/material.dart';

class AppTypography {
  // Títulos
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static const h3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static const titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  // Corpo de texto
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Botões e elementos interativos
  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );
}
