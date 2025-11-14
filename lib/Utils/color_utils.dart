import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';

final Map<String, Color> coloresDisponibles = {
  'Rosa': const Color(0xFFF5A1EA),
  'Azul cielo': const Color(0xFF90CAF9),
  'Rojo coral': const Color(0xFFFF8A80),
  'Verde menta': const Color(0xFF80CBC4),
  'Amarillo pastel': const Color(0xFFFFF59D),
  'Morado lavanda': const Color(0xFFCE93D8),
  'Naranja suave': const Color(0xFFFFCC80),
  'Turquesa': const Color(0xFF4DD0E1),
  'Verde lima': const Color(0xFFDCE775),
  'Celeste': const Color(0xFF81D4FA),
  'Melocotón': const Color(0xFFFFAB91),
  'Gris claro': const Color(0xFFCFD8DC),
  'Azul petróleo': const Color(0xFF4DB6AC),
  'Fucsia': const Color(0xFFF06292),
  'Verde bosque': const Color(0xFF66BB6A),
  'Amarillo sol': const Color(0xFFFFEB3B),
  'Lavanda': const Color(0xFFE1BEE7),
  'Cian': const Color(0xFF00BCD4),
  'Mandarina': const Color(0xFFFFA726),
  'Verde oliva': const Color(0xFF9CCC65),
};

Color obtenerColorDesdeHex(String hex) {
  return Color(int.parse(hex, radix: 16)).withOpacity(1);
}

final Map<String, Color> coloresUsuarios = {
  'mama': const Color.fromARGB(255, 245, 161, 234),
  'papa': Colors.blueAccent.shade100,
  'alex': const Color.fromARGB(255, 235, 141, 141),
  'erik': const Color(0xFF42B14D),
};
Color obtenerColorUsuario(UserModel usuario) {
  // 1. Si tiene colorHex guardado, úsalo
  if (usuario.colorHex != null && usuario.colorHex!.isNotEmpty) {
    return Color(int.parse(usuario.colorHex!, radix: 16));
  }

  // 2. Si está en el mapa de colores manuales, úsalo
  final idLimpio = usuario.id.toLowerCase();
  if (coloresUsuarios.containsKey(idLimpio)) {
    return coloresUsuarios[idLimpio]!;
  }

  // 3. Si no tiene color, genera uno pastel automático
  final hash = idLimpio.hashCode;
  final r = (hash & 0xFF0000) >> 16;
  final g = (hash & 0x00FF00) >> 8;
  final b = (hash & 0x0000FF);
  return Color.fromARGB(255, (r + 180) % 256, (g + 180) % 256, (b + 180) % 256);
}
