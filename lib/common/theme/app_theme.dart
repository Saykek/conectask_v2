import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF2E7D75), 
        secondary: const Color(0xFF80CBC4), 
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFE0F7FA), // fondo menta suave
      textTheme: base.textTheme.copyWith(
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF263238), // gris oscuro
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontFamily: 'Nunito',
          fontSize: 15,
          color: const Color(0xFF37474F), // gris medio
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF2E7D75)),
      cardTheme: const CardThemeData(
        color: Color(0xFFB2DFDB), // verde agua claro
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2E7D75),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(46, 125, 117, 1),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        // circulo
  thumbColor: WidgetStateProperty.resolveWith<Color>(
  (states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF2E7D75); // activo
    }
    return Color.fromARGB(255, 249, 252, 251); // apagado
  },
), 
// pista
trackColor: WidgetStateProperty.resolveWith<Color>(
  (states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF80CBC4); // pista activa
    }
    return const Color(0xFF80CBC4); // pista apagada
  },
),
trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent; // sin borde cuando está activo
      }
      return Colors.transparent; // sin borde cuando está apagado
    },
  ),
  trackOutlineWidth: WidgetStateProperty.all(0), // elimina grosor de la línea
),
     //  Barra de progreso integrada
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF2E7D75), // color principal de la barra
        linearTrackColor: Color.fromARGB(255, 239, 247, 246), // color de fondo de la barra
      ),
    );
  }


  // Tema oscuro
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF81C784), // verde más suave en oscuro
        secondary: const Color(0xFFFF8A65), // coral más claro
        surface: const Color(0xFF121212),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: base.textTheme.copyWith(
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF81C784)),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Color(0xFF81C784),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF81C784),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
