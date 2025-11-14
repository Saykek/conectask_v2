import 'package:flutter/material.dart';

final Map<String, Color> coloresUsuarios = {
  'mama': const Color.fromARGB(255, 245, 161, 234),
  'papa': Colors.blueAccent.shade100,
  'alex': const Color.fromARGB(255, 235, 141, 141),
  'erik': const Color(0xFF42B14D),
};
Color obtenerColorUsuario(String id) {
  final idLimpio = id.toLowerCase();

  if (coloresUsuarios.containsKey(idLimpio)) {
    return coloresUsuarios[idLimpio]!;
  }

  // Generar color pastel único si no está en el mapa
  final hash = idLimpio.hashCode;
  final r = (hash & 0xFF0000) >> 16;
  final g = (hash & 0x00FF00) >> 8;
  final b = (hash & 0x0000FF);
  return Color.fromARGB(255, (r + 180) % 256, (g + 180) % 256, (b + 180) % 256);
}
