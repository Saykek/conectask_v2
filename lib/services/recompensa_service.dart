import 'package:firebase_database/firebase_database.dart';
import '../common/constants/constant.dart';
import '../models/recompensa_model.dart';

class RecompensaService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    AppFieldsConstants.recompensasMin,
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
    final snapshot = await _dbRef.get();
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
    String usuarioNombre,
    RecompensaModel recompensa,
  ) async {
    final canjeoRef = FirebaseDatabase.instance.ref('canjeos').push();
    await canjeoRef.set({
      'usuarioId': userId,
      'usuarioNombre': usuarioNombre.toLowerCase(),
      'recompensaId': recompensa.id,
      'recompensaNombre': recompensa.nombre,
      'coste': recompensa.coste,
      'fecha': DateTime.now().toIso8601String(),
      'entregado': false,
    });
  }

  Future<void> marcarComoUsada(String recompensaId) async {
    await _dbRef.child(recompensaId).update({'usada': true});
  }

  Future<void> marcarEntregado(String canjeoId, bool entregado) async {
  final ref = FirebaseDatabase.instance.ref('canjeos/$canjeoId');
  await ref.update({'entregado': entregado});
}

// Método para escuchar cualquier cambio
Stream<List<RecompensaModel>> streamRecompensas() {
  return _dbRef.onValue.map((event) {
    final snapshot = event.snapshot;

    if (!snapshot.exists) {
      return <RecompensaModel>[];
    }

    final raw = snapshot.value as Map<dynamic, dynamic>;

    return raw.entries.map((e) {
      final id = e.key.toString();
      final data = Map<String, dynamic>.from(e.value as Map);
      return RecompensaModel.fromMap(id, data);
    }).toList();
  });
}

}
