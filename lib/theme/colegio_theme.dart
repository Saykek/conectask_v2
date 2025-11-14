import 'package:flutter/material.dart';

class ColegioTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      scaffoldBackgroundColor: Colors.grey.shade100,
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static Color colorPorAsignatura(String asignatura) {
    switch (asignatura.toLowerCase()) {
      case 'matemáticas':
        return Colors.indigo.shade100;
      case 'lengua':
        return Colors.red.shade100;
      case 'ciencias':
      case 'naturales':
        return Colors.green.shade100;
      case 'inglés':
        return Colors.blue.shade100;
      case 'sociales':
        return Colors.orange.shade100;
      case 'arte':
        return Colors.purple.shade100;
      case 'educación física':
        return Colors.teal.shade100;
      case 'música':
        return Colors.pink.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  static Color colorIconoPorAsignatura(String asignatura) {
    switch (asignatura.toLowerCase()) {
      case 'matemáticas':
        return Colors.indigo.shade400;
      case 'lengua':
        return Colors.red.shade400;
      case 'ciencias':
      case 'naturales':
        return Colors.green.shade400;
      case 'inglés':
        return Colors.blue.shade400;
      case 'sociales':
        return Colors.orange.shade400;
      case 'arte':
        return Colors.purple.shade400;
      case 'educación física':
        return Colors.teal.shade400;
      case 'música':
        return Colors.pink.shade400;
      default:
        return Colors.grey.shade600;
    }
  }
}
