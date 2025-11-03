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
    };
  }

  // Crear objeto desde Map leído de Realtime Database
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      responsable: map['responsable'] ?? '',
      fecha: map['fecha'] != null
          ? DateTime.parse(map['fecha'])
          : DateTime.now(),
      prioridad: map['prioridad'] ?? 'normal',
      estado: map['estado'] ?? 'pendiente',
      recompensa: map['recompensa'],
      validadaPor: map['validadaPor'],
    );
  }
}
