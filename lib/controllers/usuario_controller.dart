import 'package:conectask_v2/common/widgets/receta_modulo.dart';
import 'package:flutter/material.dart';
import '../common/constants/constant.dart';
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
    return usuario?.rol == AppConstants.rolAdulto || usuario?.rol == AppConstants.rolAdmin;
  }

  String getNombreUsuario(String id) {
    final usuario = getUsuarioPorId(id);
    if (usuario == null) return AppConstants.desconocido;
    if (usuario.nombre.isNotEmpty) return usuario.nombre;
    if (usuario.rol == AppConstants.rolAdmin) return AppConstants.administrador;
    return AppConstants.desconocido;
  }

  // GENERAR COLOR USUARIO

  String generarColorHexDesdeNombre(String nombre) {
    final hash = nombre.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    final color = Color.fromARGB(
      255,
      (r + 180) % 256,
      (g + 180) % 256,
      (b + 180) % 256,
    );
    return color.value.toRadixString(16);
  }
  /// Devuelve los módulos visibles según el rol del usuario
  
  List<Map<String, dynamic>> obtenerModulosPorRol(String rol) {
    final todosModulos = [
      {
        'titulo': 'Tareas',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/tarea.json',
          factor: 1,
        ),
      },
      {
        'titulo': 'Menú semanal',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/receta_ani.json',
          factor: 1,
        ),
      },
      {
        'titulo': 'Colegio',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/colegio.json',
          factor: 1,
        ),
      },
      {
        'titulo': 'Casa',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/home_conection.json',
          factor: 1.2,
        ),
      },
      {
        'titulo': 'Recompensas',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/regalo_home.json',
          factor: 2.1,
        ),
      },
      {
        'titulo': 'Calendario',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/calendario.json',
          factor: 1,
        ),
      },
      {
        'titulo': 'Configuración',
        'icono': RecetaModulo(
          assetPath: 'assets/animaciones/configuracion.json',
          factor: 1,
        ),
      },
    ];

    // Filtrado según rol
    if (rol.toLowerCase() == 'niño') {
      return todosModulos
          .where((modulo) =>
              modulo['titulo'] != 'Casa' && modulo['titulo'] != 'Configuración')
          .toList();
    }

    return todosModulos;
  }

}
