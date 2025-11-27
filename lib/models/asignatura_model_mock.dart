import 'package:flutter/material.dart';

class AsignaturaModelMock {
  final String nombre;
  final IconData icono;
  final List<Map<String, String>> examenes;
  final List<Map<String, String>> notas;
  final List<Map<String, String>> excursiones;

  AsignaturaModelMock({
    required this.nombre,
    required this.icono,
    required this.examenes,
    required this.notas,
    required this.excursiones,
  });
}