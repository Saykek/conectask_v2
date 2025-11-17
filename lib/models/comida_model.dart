class ComidaModel {
  final String nombre;
  final String? foto;        // URL de imagen
  final String? url;         // Enlace a receta externa
  final String? ingredientes;
  final String? receta;      // Texto de pasos de preparación
  final String? notas;       // Observaciones personales
  final int? porciones;      // Nº de raciones
  final int? tiempoMin;      // Tiempo estimado en minutos
  final List<String>? tags;  // Etiquetas: "vegano", "sin gluten", etc.

  ComidaModel({
    required this.nombre,
    this.foto,
    this.url,
    this.ingredientes,
    this.receta,
    this.notas,
    this.porciones,
    this.tiempoMin,
    this.tags,
  });

  factory ComidaModel.fromMap(Map<String, dynamic> map) {
    return ComidaModel(
      nombre: (map['nombre'] ?? '').toString(),
      foto: map['foto']?.toString(),
      url: map['url']?.toString(),
      ingredientes: map['ingredientes']?.toString(),
      receta: map['receta']?.toString(),
      notas: map['notas']?.toString(),
      porciones: map['porciones'] is int ? map['porciones'] as int : int.tryParse('${map['porciones'] ?? ''}'),
      tiempoMin: map['tiempoMin'] is int ? map['tiempoMin'] as int : int.tryParse('${map['tiempoMin'] ?? ''}'),
      tags: (map['tags'] is List)
          ? (map['tags'] as List).map((e) => e.toString()).toList()
          : (map['tags'] is String && (map['tags'] as String).isNotEmpty)
              ? (map['tags'] as String).split(',').map((e) => e.trim()).toList()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      if (foto != null && foto!.isNotEmpty) 'foto': foto,
      if (url != null && url!.isNotEmpty) 'url': url,
      if (ingredientes != null && ingredientes!.isNotEmpty) 'ingredientes': ingredientes,
      if (receta != null && receta!.isNotEmpty) 'receta': receta,
      if (notas != null && notas!.isNotEmpty) 'notas': notas,
      if (porciones != null) 'porciones': porciones,
      if (tiempoMin != null) 'tiempoMin': tiempoMin,
      if (tags != null && tags!.isNotEmpty) 'tags': tags,
    };
  }

  ComidaModel copyWith({
    String? nombre,
    String? foto,
    String? url,
    String? ingredientes,
    String? receta,
    String? notas,
    int? porciones,
    int? tiempoMin,
    List<String>? tags,
  }) {
    return ComidaModel(
      nombre: nombre ?? this.nombre,
      foto: foto ?? this.foto,
      url: url ?? this.url,
      ingredientes: ingredientes ?? this.ingredientes,
      receta: receta ?? this.receta,
      notas: notas ?? this.notas,
      porciones: porciones ?? this.porciones,
      tiempoMin: tiempoMin ?? this.tiempoMin,
      tags: tags ?? this.tags,
    );
  }
}