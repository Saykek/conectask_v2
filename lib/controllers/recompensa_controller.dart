import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/recompensa_service.dart';
import 'package:firebase_database/firebase_database.dart';

class RecompensaController {
  final RecompensaService _service = RecompensaService();

  Future<List<RecompensaModel>> getRecompensasPara(UserModel user) async {
    final todas = await _service.obtenerRecompensas();
    return user.rol == 'admin'
        ? todas
        : todas.where((r) => r.visible).toList();
  }

  Future<int> canjear(UserModel user, RecompensaModel recompensa) async {
  final puntos = user.puntos ?? 0;
  if (puntos >= recompensa.coste) {
    final nuevosPuntos = puntos - recompensa.coste;
    await _service.actualizarPuntos(user.id, nuevosPuntos);
    await _service.registrarCanjeo(user.id, recompensa);
    return nuevosPuntos;
  } else {
    throw Exception('No tienes suficientes puntos');
  }
}
Future<List<Map<String, dynamic>>> obtenerCanjeos(String userId) async {
  final ref = FirebaseDatabase.instance.ref('canjeos');
  final snapshot = await ref.orderByChild('usuario').equalTo(userId).get();

  if (snapshot.exists) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries.map((e) => Map<String, dynamic>.from(e.value)).toList();
  } else {
    return [];
  }
}

Future<List<RecompensaModel>> getTodasLasRecompensas() async {
  final todas = await _service.obtenerRecompensas();
  return todas; // Devuelve todas sin filtrar
}
}