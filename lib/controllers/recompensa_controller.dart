import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/recompensa_service.dart';
import 'package:conectask_v2/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';

class RecompensaController {
  final RecompensaService _service = RecompensaService();
  final UserService _userService = UserService();

  /// Recompensas filtradas para un usuario (oculta las usadas)
  Future<List<RecompensaModel>> getRecompensasPara(UserModel user) async {
    final todas = await _service.obtenerRecompensas();
    return todas.where((r) => r.usada != true).toList();
  }

  /// Devuelve todas las recompensas sin filtrar
  Future<List<RecompensaModel>> getTodasLasRecompensas() async {
    final todas = await _service.obtenerRecompensas();
    return todas;
  }

  /// Canjea una recompensa: resta puntos activos y registra el canjeo
  Future<UserModel> canjear(UserModel user, RecompensaModel recompensa) async {
    final puntos = user.puntos ?? 0;
    if (puntos >= recompensa.coste) {
      final nuevosPuntos = puntos - recompensa.coste;

      //  Resta puntos activos en Firebase
      await _userService.restarPuntos(user.id, recompensa.coste);

      //  Registra el canjeo
      await _service.registrarCanjeo(user.id, recompensa);

      // marcar recompensa como usada
      await _service.marcarComoUsada(recompensa.id);

      //  Actualiza el objeto en memoria
      final usuarioActualizado = user.copyWith(puntos: nuevosPuntos);

      return usuarioActualizado;
    } else {
      throw Exception('No tienes suficientes puntos');
    }
  }

  /// Suma puntos (activos + acumulados)
  Future<void> sumarPuntos(UserModel user, int puntos) async {
    await _userService.sumarPuntos(user.id, puntos);
  }

  /// Calcula el nivel a partir de puntos_acumulados
  Future<int> calcularNivel(UserModel user) async {
    final usuario = await _userService.obtenerUsuario(user.id);
    if (usuario != null) {
      return (usuario.puntosAcumulados ?? 0) ~/ 100;
    }
    return 0;
  }

  /// Obtiene todos los canjeos de un usuario
  Future<List<Map<String, dynamic>>> obtenerCanjeos(String userId) async {
    final ref = FirebaseDatabase.instance.ref('canjeos');
    final snapshot = await ref.orderByChild('usuario').equalTo(userId).get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((e) => Map<String, dynamic>.from(e.value))
          .toList();
    } else {
      return [];
    }
  }
}
