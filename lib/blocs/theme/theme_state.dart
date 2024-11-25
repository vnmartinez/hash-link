import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({this.themeMode = ThemeMode.system});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
