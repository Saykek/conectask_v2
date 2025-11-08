class ConfiguracionModel {
  String tema;
  String idioma;
  String rol;
  bool notificacionesActivas;
  String urlServidor;

  ConfiguracionModel({
    required this.tema,
    required this.idioma,
    required this.rol,
    required this.notificacionesActivas,
    required this.urlServidor,
  });

  factory ConfiguracionModel.fromMap(Map<String, dynamic> map) {
    return ConfiguracionModel(
      tema: map['tema'] ?? 'claro',
      idioma: map['idioma'] ?? 'es',
      rol: map['rol'] ?? 'niño',
      notificacionesActivas: map['notificacionesActivas'] ?? true,
      urlServidor: map['urlServidor'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tema': tema,
      'idioma': idioma,
      'rol': rol,
      'notificacionesActivas': notificacionesActivas,
      'urlServidor': urlServidor,
    };
  }
}
