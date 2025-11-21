import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF4A3AFF), // azul intenso
        secondary: const Color(0xFF6F1EFA), // morado vibrante
        surface: Colors.white,
        surfaceContainerHighest: Colors.grey.shade100,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: base.textTheme.copyWith(
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF6F1EFA)),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A3AFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A3AFF),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            inherit: true,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  // Tema oscuro
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF6F1EFA), // morado vibrante
        secondary: const Color(0xFF4A3AFF), // azul intenso
        surface: const Color(0xFF0D0D0D),
        surfaceContainerHighest: const Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      textTheme: base.textTheme.copyWith(
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF4A3AFF)),
      cardTheme: const CardThemeData(
        color: Color(0xFF1A1A1A),
        elevation: 4,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6F1EFA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F1EFA),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            inherit: true,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}