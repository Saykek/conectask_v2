import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  FirebaseAuth get auth => _auth;

  // Método de login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Autenticación con Firebase Auth
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // Obtener usuario con nombre desde Realtime Database
      UserModel? user = await _userService.obtenerUsuario(uid);
      return user;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Método de registro
  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid != null) {
        // Guardar nombre y email en Realtime Database
        await _userService.guardarUsuario(
          UserModel(id: uid, nombre: nombre, email: email, rol: 'admin'),
        );
      }

      return true;
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Login para niños (sin Firebase Auth)
  Future<UserModel?> loginNino({
    required String usuario,
    required String pin,
  }) async {
    try {
      // Buscar usuario por nombre y PIN en Realtime Database
      UserModel? user = await _userService.obtenerUsuarioPorNombre(usuario);
      print('PIN guardado: ${user?.pin}, PIN ingresado: $pin');

      if (user != null && user.rol == 'niño' && user.pin == pin) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al iniciar sesión como niño: $e');
      return null;
    }
  }
}
