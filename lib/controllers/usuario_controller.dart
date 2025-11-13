import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UsuarioController extends ChangeNotifier {
  final UserService _userService = UserService();

  List<UserModel> usuarios = [];

  Future<void> cargarUsuarios() async {
    try {
      usuarios = await _userService.obtenerTodosLosUsuarios();
      print('✅ Usuarios cargados en UsuarioController: ${usuarios.length}');
      notifyListeners();
    } catch (e) {
      print('🚨 Error al cargar usuarios en UsuarioController: $e');
    }
  }

  UserModel? getUsuarioPorId(String id) {
    return usuarios.firstWhere(
      (u) => u.id == id,
      orElse: () => UserModel(id: id, nombre: '', rol: ''),
    );
  }

  bool esAdulto(String id) {
    final usuario = getUsuarioPorId(id);
    return usuario?.rol == 'adulto' || usuario?.rol == 'admin';
  }

  String getNombreUsuario(String id) {
    final usuario = getUsuarioPorId(id);
    if (usuario == null) return 'Desconocido';
    if (usuario.nombre.isNotEmpty) return usuario.nombre;
    if (usuario.rol == 'admin') return 'Administrador';
    return 'Desconocido';
  }
}
