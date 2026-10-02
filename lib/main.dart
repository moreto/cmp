import 'package:flutter/material.dart';
import 'component_showcase_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppFont _selectedFont = AppFont.overlockSc;

  void _handleThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _handleFontChanged(AppFont font) {
    setState(() {
      _selectedFont = font;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Componentes Flutter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(font: _selectedFont),
      darkTheme: AppTheme.darkTheme(font: _selectedFont),
      themeMode: _themeMode,
      home: ComponentShowcaseScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _handleThemeModeChanged,
        selectedFont: _selectedFont,
        onFontChanged: _handleFontChanged,
      ),
    );
  }
}
