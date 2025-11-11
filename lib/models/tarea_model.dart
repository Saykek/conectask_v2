class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final String responsable; // UID del usuario responsable
  final DateTime fecha;
  final String prioridad; // "urgente", "normal", "largo_plazo"
  final String estado; // "pendiente", "hecha", "validada"
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
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'responsable': responsable,
      'fecha': fecha.toIso8601String(),
      'prioridad': prioridad,
      'estado': estado,
      'recompensa': recompensa,
      'validadaPor': validadaPor,
      'puntos': puntos,
    };
  }

  // Crear objeto desde Map leído de Realtime Database
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      responsable: map['responsable'] ?? '',
      fecha: _parseFecha(map['fecha']),
      prioridad: map['prioridad'] ?? 'normal',
      estado: map['estado'] ?? 'pendiente',
      recompensa: map['recompensa'],
      validadaPor: map['validadaPor'],
      puntos: map['puntos'] != null ? map['puntos'] as int : null,
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
