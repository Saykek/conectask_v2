import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class UserService {
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
    'usuarios',
  );

  Future<void> guardarUsuario(UserModel user) async {
    try {
      await usersRef.child(user.id).set(user.toMap());
    } catch (e) {
      print('Error al guardar usuario: $e');
      rethrow;
    }
  }

  Future<UserModel?> obtenerUsuario(String uid) async {
    try {
      final snapshot = await usersRef.child(uid).get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return UserModel.fromMap(uid, data);
      }
      return null;
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }

  // 🔍 Nuevo método: buscar niño por nombre
  Future<UserModel?> obtenerUsuarioPorNombre(String nombre) async {
    try {
      final snapshot = await usersRef.get();
      print('Snapshot obtenido: ${snapshot.value}');

      if (snapshot.exists) {
        print('entrando en if snapshot.exists');
        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>;
          final id = child.key ?? '';
          final map = Map<String, dynamic>.from(data);
          print('Leyendo: nombre=${map['nombre']}, rol=${map['rol']}');

          if (map['nombre'].toString().toLowerCase().trim() ==
                  nombre.toLowerCase().trim() &&
              map['rol'].toString().toLowerCase().trim() == 'niño') {
            print(
              'Usuario encontrado: ${map['nombre']}, pin: ${map['pin']}, Rol: ${map['rol']}',
            );
            return UserModel.fromMap(id, map);
          }
        }
      }

      return null;
    } catch (e) {
      print('Error al buscar usuario por nombre: $e');
      return null;
    }
  }
}
