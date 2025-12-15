import '../common/constants/constant.dart';

class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final String responsable; // UID del usuario responsable
  final DateTime fecha;
  final String prioridad; // valores en AppConstants.prioridades
  final String estado; // valores en AppConstants.estadoPendiente, etc.
  final String? recompensa;
  final String? validadaPor;
  final int? puntos;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.prioridad,
    required this.estado,
    this.recompensa,
    this.validadaPor,
    this.puntos,
  });

  // Convertir a Map para Realtime Database
  Map<String, dynamic> toMap() {
    return {
      AppFieldsConstants.id: id,
      AppFieldsConstants.titulo: titulo,
      AppFieldsConstants.descripcion: descripcion,
      AppFieldsConstants.responsable: responsable,
      AppFieldsConstants.fecha: fecha.toIso8601String(),
      AppFieldsConstants.prioridad: prioridad,
      AppFieldsConstants.estado: estado,
      AppFieldsConstants.recompensa: recompensa,
      AppFieldsConstants.validadaPor: validadaPor,
      AppFieldsConstants.puntos: puntos,
    };
  }

  // Crear objeto desde Map leído de Realtime Database
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map[AppFieldsConstants.id] ?? '',
      titulo: map[AppFieldsConstants.titulo] ?? '',
      descripcion: map[AppFieldsConstants.descripcion] ?? '',
      responsable: map[AppFieldsConstants.responsable] ?? '',
      fecha: _parseFecha(map[AppFieldsConstants.fecha]),
      prioridad: map[AppFieldsConstants.prioridad] ??
          AppFieldsConstants.prioridadPorDefecto,
      estado: map[AppFieldsConstants.estado] ??
          AppFieldsConstants.estadoPorDefecto,
      recompensa: map[AppFieldsConstants.recompensa],
      validadaPor: map[AppFieldsConstants.validadaPor],
      puntos: map[AppFieldsConstants.puntos] != null
          ? map[AppFieldsConstants.puntos] as int
          : null,
    );
  }

  static DateTime _parseFecha(dynamic valor) {
    try {
      if (valor is String && valor.isNotEmpty) {
        return DateTime.parse(valor);
      }
    } catch (_) {}
    return DateTime.now(); // Valor por defecto si falla
  }
}
