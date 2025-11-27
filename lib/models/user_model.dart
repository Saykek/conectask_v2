class UserModel {
  final String id;
  final String nombre;
  final String? email;
  final String rol;
  final String? pin;
  final int? nivel;
  final int? puntos;
  final int? puntosAcumulados;
  final String? colorHex;

  UserModel({
    required this.id,
    required this.nombre,
    this.email,
    required this.rol,
    this.pin,
    this.nivel,
    this.puntos,
    this.puntosAcumulados,
    this.colorHex,
  });

  /// Método para crear una copia modificada del objeto
  UserModel copyWith({
    String? id,
    String? nombre,
    String? email,
    String? rol,
    String? pin,
    int? nivel,
    int? puntos,
    int? puntosAcumulados,
    String? colorHex,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      pin: pin ?? this.pin,
      nivel: nivel ?? this.nivel,
      puntos: puntos ?? this.puntos,
      puntosAcumulados: puntosAcumulados ?? this.puntosAcumulados,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  /// Convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'rol': rol,
    };

    if (email != null) map['email'] = email;
    if (pin != null) map['pin'] = pin;
    if (nivel != null) map['nivel'] = nivel;
    if (puntos != null) map['puntos'] = puntos;
    if (puntosAcumulados != null) map['puntos_acumulados'] = puntosAcumulados;
    if (colorHex != null) map['colorHex'] = colorHex;

    return map;
  }

  /// Crear objeto desde Map de Firebase
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      email: map['email'],
      rol: map['rol'] ?? 'niño',
      pin: map['pin']?.toString(),
      nivel: map['nivel'],
      puntos: map['puntos'],
      puntosAcumulados: map['puntos_acumulados'],
      colorHex: map['colorHex'],
    );
  }
}