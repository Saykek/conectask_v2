import 'package:firebase_database/firebase_database.dart';

class ConfiguracionService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>?> leerConfiguracion(String uid) async {
    final snapshot = await _db.child('configuraciones/$uid').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  Future<void> guardarConfiguracion(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.child('configuraciones/$uid').set(data);
  }

  Future<void> actualizarConfiguracion(
    String uid,
    Map<String, dynamic> cambios,
  ) async {
    await _db.child('configuraciones/$uid').update(cambios);
  }

  Future<void> borrarConfiguracion(String uid) async {
    await _db.child('configuraciones/$uid').remove();
  }
}
