import '../models/user_model.dart';

final List<UserModel> usuariosLocales = [
  UserModel(id: 'mama', nombre: 'Mamá', rol: 'admin'),
  UserModel(id: 'papa', nombre: 'Papá', rol: 'adulto'),
  UserModel(id: 'alex', nombre: 'Álex', rol: 'niño'),
  UserModel(id: 'erik', nombre: 'Erik', rol: 'niño'),
];

String getNombreUsuario(String id) {
  final usuario = usuariosLocales.firstWhere(
    (u) => u.id == id,
    orElse: () => UserModel(id: id, nombre: '', rol: ''),
  );

  if (usuario.nombre.isNotEmpty) return usuario.nombre;

  if (usuario.rol == 'admin') return 'Administrador';

  return 'Desconocido';
}

bool esAdulto(String id) {
  return usuariosLocales.any((u) => u.id == id && u.rol == 'adulto');
}