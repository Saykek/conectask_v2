class Examen {
  final String id;
  final String titulo;
  final String descripcion;
  final String responsable;
  final DateTime fecha;
  final String estado;
  final String prioridad;
  final String uidAlumno; // Nuevo: ID del alumno
  final String asignatura; // Nuevo: nombre de la asignatura
  final double? nota; // Nuevo: nota del examen (nullable)
  final String? comentario; // Nuevo: observaciones (nullable)

  Examen({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.responsable,
    required this.fecha,
    required this.estado,
    required this.prioridad,
    required this.uidAlumno,
    required this.asignatura,
    this.nota,
    this.comentario,
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
      uidAlumno: json['uidAlumno'] ?? '',
      asignatura: json['asignatura'] ?? '',
      nota: (json['nota'] != null)
          ? double.tryParse(json['nota'].toString())
          : null,
      comentario: json['comentario'],
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
      'uidAlumno': uidAlumno,
      'asignatura': asignatura,
      'nota': nota,
      'comentario': comentario,
    };
  }
}
