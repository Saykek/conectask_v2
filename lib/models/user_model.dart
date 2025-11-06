class UserModel {
  final String id;
  final String nombre;
  final String? email;
  final String rol;
  final String? pin;
  final int? nivel;
  final int? puntos;

  UserModel({
    required this.id,
    required this.nombre,
    this.email,
    required this.rol,
    this.pin,
    this.nivel,
    this.puntos,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      if (email != null) 'email': email,
      'rol': rol,
      if (pin != null) 'pin': pin,
      if (nivel != null) 'nivel': nivel,
      if (puntos != null) 'puntos': puntos,
    };
    return map;
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      email: map['email'],
      rol: map['rol'] ?? 'niño',
      pin: map['pin']?.toString(),
      nivel: map['nivel'],
      puntos: map['puntos'],
    );
  }
}
