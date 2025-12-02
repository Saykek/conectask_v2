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
      AppTareaFieldsConstants.id: id,
      AppTareaFieldsConstants.titulo: titulo,
      AppTareaFieldsConstants.descripcion: descripcion,
      AppTareaFieldsConstants.responsable: responsable,
      AppTareaFieldsConstants.fecha: fecha.toIso8601String(),
      AppTareaFieldsConstants.prioridad: prioridad,
      AppTareaFieldsConstants.estado: estado,
      AppTareaFieldsConstants.recompensa: recompensa,
      AppTareaFieldsConstants.validadaPor: validadaPor,
      AppTareaFieldsConstants.puntos: puntos,
    };
  }

  // Crear objeto desde Map leído de Realtime Database
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map[AppTareaFieldsConstants.id] ?? '',
      titulo: map[AppTareaFieldsConstants.titulo] ?? '',
      descripcion: map[AppTareaFieldsConstants.descripcion] ?? '',
      responsable: map[AppTareaFieldsConstants.responsable] ?? '',
      fecha: _parseFecha(map[AppTareaFieldsConstants.fecha]),
      prioridad: map[AppTareaFieldsConstants.prioridad] ??
          AppTareaFieldsConstants.prioridadPorDefecto,
      estado: map[AppTareaFieldsConstants.estado] ??
          AppTareaFieldsConstants.estadoPorDefecto,
      recompensa: map[AppTareaFieldsConstants.recompensa],
      validadaPor: map[AppTareaFieldsConstants.validadaPor],
      puntos: map[AppTareaFieldsConstants.puntos] != null
          ? map[AppTareaFieldsConstants.puntos] as int
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
