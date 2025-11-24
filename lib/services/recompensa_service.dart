import 'package:firebase_database/firebase_database.dart';
import '../models/recompensa_model.dart';

class RecompensaService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    'recompensas',
  );

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
    final ref = FirebaseDatabase.instance.ref('recompensas');
    final snapshot = await ref.get();

    if (!snapshot.exists) return [];

    final raw = snapshot.value as Map<dynamic, dynamic>;
    final list = raw.entries.map((e) {
      final id = e.key.toString();
      final data = Map<String, dynamic>.from(e.value as Map);
      print(
        'DEBUG SERVICE: id=$id usada=${data['usada']} disponible=${data['disponible']} nombre=${data['nombre']}',
      );

      final r = RecompensaModel.fromMap(id, data);
      print(
        'DEBUG SERVICE: model id=${r.id} nombre=${r.nombre} usada=${r.usada}',
      );
      return r;
    }).toList();

    return list;
  }

  Future<void> actualizarPuntos(String userId, int nuevosPuntos) async {
    final userRef = FirebaseDatabase.instance.ref('usuarios/$userId/puntos');
    await userRef.set(nuevosPuntos);
  }

  Future<void> registrarCanjeo(
    String userId,
    RecompensaModel recompensa,
  ) async {
    final canjeoRef = FirebaseDatabase.instance.ref('canjeos').push();
    await canjeoRef.set({
      'usuario': userId,
      'recompensaId': recompensa.id,
      'recompensaNombre': recompensa.nombre,
      'coste': recompensa.coste,
      'fecha': DateTime.now().toIso8601String(),
    });
  }

  Future<void> marcarComoUsada(String recompensaId) async {
    await _dbRef.child(recompensaId).update({'usada': true});
  }
}
