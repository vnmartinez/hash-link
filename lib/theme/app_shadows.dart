import 'package:flutter/material.dart';

class AppShadows {
  static const low = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const high = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}
