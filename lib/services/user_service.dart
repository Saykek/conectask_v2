import 'package:firebase_database/firebase_database.dart';
import '../common/constants/constant.dart';
import '../models/user_model.dart';

class UserService {
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
    AppFirebaseConstants.usuarios,
  );

  Future<void> guardarUsuario(UserModel user) async {
    try {
      await usersRef.child(user.id).set(user.toMap());
    } catch (e) {
      print('Error al guardar usuario: $e');
      rethrow;
    }
  }

  // OBTENER TODOS LOS USUARIOS

  Future<List<UserModel>> obtenerTodosLosUsuarios() async {
    try {
      final snapshot = await usersRef.get();
      print('📦 Snapshot recibido: ${snapshot.value}');

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        final usuarios = data.entries.map((entry) {
          final userData = Map<String, dynamic>.from(entry.value as Map);
          final id = entry.key ?? '';
          return UserModel.fromMap(id, userData);
        }).toList();

        print('✅ Usuarios obtenidos: ${usuarios.length}');
        return usuarios;
      } else {
        print('❌ No hay datos en la ruta usuarios');
        return [];
      }
    } catch (e) {
      print('🚨 Error al obtener todos los usuarios: $e');
      return [];
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

  // buscar niño por nombre
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
          print('Leyendo: nombre=${map['nombre']}, rol=${map[AppConstants.rol]}');

          if (map['nombre'].toString().toLowerCase().trim() ==
                  nombre.toLowerCase().trim() &&
              map[AppConstants.rol].toString().toLowerCase().trim() == AppConstants.rolNino) {
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

   // SUMAR PUNTOS (activos + acumulados)
Future<void> sumarPuntos(String userId, int puntos) async {
  final refPuntos = usersRef.child(userId).child(AppFieldsConstants.puntos);              // disponibles
  final refAcumulados = usersRef.child(userId).child(AppFirebaseConstants.puntos_acumulados); // histórico

  final snapshotPuntos = await refPuntos.get();
  final snapshotAcumulados = await refAcumulados.get();

  final puntosActuales = snapshotPuntos.exists
      ? int.tryParse(snapshotPuntos.value.toString()) ?? 0
      : 0;
  final acumuladosActuales = snapshotAcumulados.exists
      ? int.tryParse(snapshotAcumulados.value.toString()) ?? 0
      : 0;

  // ✅ puntos = disponibles, acumulados = histórico
  await refPuntos.set(puntosActuales + puntos);          // suben los disponibles
  await refAcumulados.set(acumuladosActuales + puntos);  // sube el histórico
}

  // RESTAR PUNTOS (solo activos)
Future<void> restarPuntos(String userId, int puntos) async {
  final refPuntos = usersRef.child(userId).child('puntos');
  final snapshot = await refPuntos.get();

  final puntosActuales = snapshot.exists
      ? int.tryParse(snapshot.value.toString()) ?? 0
      : 0;

  final nuevosPuntos = (puntosActuales - puntos).clamp(0, puntosActuales);
  await refPuntos.set(nuevosPuntos);
}
}
