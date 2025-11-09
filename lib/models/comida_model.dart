class ComidaModel {
  final String nombre;
  final String? foto;
  final String? url;

  ComidaModel({required this.nombre, this.foto, this.url});

  factory ComidaModel.fromMap(Map<String, dynamic> map) {
    return ComidaModel(
      nombre: map['nombre'] ?? '',
      foto: map['foto'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      if (foto != null) 'foto': foto,
      if (url != null) 'url': url,
    };
  }
}
