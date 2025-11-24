class RecompensaModel {
  final String id;
  final String nombre;
  final int coste;
  final String? descripcion;
  final bool visible;
  final bool usada;

  RecompensaModel({
    required this.id,
    required this.nombre,
    required this.coste,
    this.descripcion,
    required this.visible,
    this.usada = false,
  });
  RecompensaModel copyWith({
    String? id,
    String? nombre,
    int? coste,
    String? descripcion,
    bool? visible,
    bool? usada,
  }) {
    return RecompensaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      coste: coste ?? this.coste,
      descripcion: descripcion ?? this.descripcion,
      visible: visible ?? this.visible,
      usada: usada ?? this.usada,
    );
  }

  factory RecompensaModel.fromMap(String id, Map<String, dynamic> map) {
    return RecompensaModel(
      id: id,
      nombre: map['nombre'] ?? '',
      coste: map['coste'] ?? 0,
      descripcion: map['descripcion'],
      visible: map['disponible'] ?? true,
      usada: map['usada'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'coste': coste,
      if (descripcion != null) 'descripcion': descripcion,
      'disponible': visible,
      'usada': usada,
    };
  }
}
