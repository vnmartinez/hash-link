import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 8),
        Text(subtitle, style: subtitleStyle),
      ],
    );
  }
}
