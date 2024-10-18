import 'package:collingo/presentation/themes/darkmode.dart';
import 'package:collingo/presentation/themes/lightmode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ThemeState class to hold current theme data
class ThemeState {
  final ThemeData themeData;

  const ThemeState({required this.themeData});
}

// Cubit to handle theme switching
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeData: darkMode)); // Default to lightMode

  // Method to toggle between light and dark mode
  void toggleTheme() {
    if (state.themeData == lightMode) {
      emit(ThemeState(themeData: darkMode));
    } else {
      emit(ThemeState(themeData: lightMode));
    }
  }
}
