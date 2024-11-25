import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    emit(state.copyWith(themeMode: newThemeMode));
  }

  void _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
