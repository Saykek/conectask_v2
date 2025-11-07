import 'package:firebase_database/firebase_database.dart';
import '../models/recompensa_model.dart';

class RecompensaService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('recompensas');

  Future<void> guardarRecompensa(RecompensaModel recompensa) async {
    final nuevaRef = _dbRef.push();
    await nuevaRef.set(recompensa.toMap());
  }

  Future<void> actualizarRecompensa(RecompensaModel recompensa) async {
    if (recompensa.id.isEmpty) return;
    await _dbRef.child(recompensa.id).set(recompensa.toMap());
  }

  Future<void> eliminarRecompensa(String id) async {
    await _dbRef.child(id).remove();
  }

  Future<List<RecompensaModel>> obtenerRecompensas() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        final id = entry.key as String;
        final map = Map<String, dynamic>.from(entry.value);
        return RecompensaModel.fromMap(id, map);
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> actualizarPuntos(String userId, int nuevosPuntos) async {
  final userRef = FirebaseDatabase.instance.ref('usuarios/$userId/puntos');
  await userRef.set(nuevosPuntos);
}

Future<void> registrarCanjeo(String userId, RecompensaModel recompensa) async {
  final canjeoRef = FirebaseDatabase.instance.ref('canjeos').push();
  await canjeoRef.set({
    'usuario': userId,
    'recompensaId': recompensa.id,
    'recompensaNombre': recompensa.nombre,
    'coste': recompensa.coste,
    'fecha': DateTime.now().toIso8601String(),
  });
}
}