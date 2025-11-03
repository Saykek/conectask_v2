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
}
