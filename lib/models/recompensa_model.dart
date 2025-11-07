class RecompensaModel {
  final String id;
  final String nombre;
  final int coste;
  final String? descripcion;
  final bool visible;

  RecompensaModel({
    required this.id,
    required this.nombre,
    required this.coste,
    this.descripcion,
    required this.visible,
  });

  factory RecompensaModel.fromMap(String id, Map<String, dynamic> map) {
    return RecompensaModel(
      id: id,
      nombre: map['nombre'] ?? '',
      coste: map['coste'] ?? 0,
      descripcion: map['descripcion'],
      visible: map['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'coste': coste,
      if (descripcion != null) 'descripcion': descripcion,
      'disponible': visible,
    };
  }
}