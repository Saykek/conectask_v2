class UserModel {
  final String id; // UID de Firebase
  final String nombre;
  final String email;

  UserModel({required this.id, required this.nombre, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'email': email};
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
