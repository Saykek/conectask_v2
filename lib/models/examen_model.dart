class Examen {
  final String id;
  final String titulo;
  final String descripcion;
  final String responsable;
  final DateTime fecha;
  final String estado;
  final String prioridad;

  Examen({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.estado,
    required this.prioridad,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      responsable: json['responsable'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      estado: json['estado'] ?? 'pendiente',
      prioridad: json['prioridad'] ?? 'Media',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'responsable': responsable,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'prioridad': prioridad,
    };
  }
}