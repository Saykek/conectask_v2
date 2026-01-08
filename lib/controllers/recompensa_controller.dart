import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/recompensa_service.dart';
import 'package:conectask_v2/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../common/constants/constant.dart';

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

  // Eliminar recompensas

  Future<void> eliminarRecompensa(String id) async {
    await _service.eliminarRecompensa(id);
  }

  ///// Canjea una recompensa: resta puntos activos y registra el canjeo
  /*Future<UserModel> canjear(UserModel user, RecompensaModel recompensa) async {
  print('DEBUG CONTROLLER: usuario=${user.nombre}, puntos=${user.puntos}, coste=${recompensa.coste}');

  // leer usuario actualizado desde Firebase
  final usuarioActual = await _userService.obtenerUsuario(user.id);
  print('DEBUG CONTROLLER: usuarioActual Firebase=${usuarioActual?.nombre}, puntos=${usuarioActual?.puntos}');

  final puntos = usuarioActual?.puntos ?? 0;
  if (puntos >= recompensa.coste) {
    final nuevosPuntos = puntos - recompensa.coste;

    // Resta puntos activos en Firebase
    await _userService.restarPuntos(user.id, recompensa.coste);

    // Registra el canjeo
    await _service.registrarCanjeo(FirebaseAuth.instance.currentUser!.uid,user.nombre, recompensa);

    // marcar recompensa como usada
    await _service.marcarComoUsada(recompensa.id);

    // Actualiza el objeto en memoria
    final usuarioActualizado = usuarioActual!.copyWith(puntos: nuevosPuntos);

    return usuarioActualizado;
  } else {
    throw Exception('No tienes suficientes puntos');
  }
}*/
  //METODO NUEVO DE CANJEAR RECOMPENSA
  Future<void> canjear(UserModel user, RecompensaModel recompensa) async {
    final ref = FirebaseDatabase.instance.ref('usuarios/${user.id}');
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      throw Exception('Usuario no encontrado');
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final int puntosDisponibles = data['puntos'] ?? 0;

    if (puntosDisponibles < recompensa.coste) {
      throw Exception('No tienes suficientes puntos');
    }

    // 🔹 restar puntos disponibles
    await ref.child('puntos').set(puntosDisponibles - recompensa.coste);

    // 🔹 registrar canjeo usando directamente el id del UserModel
    await _service.registrarCanjeo(
      user.id, // << aquí usamos user.id, no FirebaseAuth
      user.nombre,
      recompensa,
    );

    // 🔹 marcar recompensa como usada
    await _service.marcarComoUsada(recompensa.id);
  }

  // *******************************************
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

  /// Obtiene todos los canjeos de un usuario por UID
  Future<List<Map<String, dynamic>>> obtenerCanjeos(String nombre) async {
    final ref = FirebaseDatabase.instance.ref('canjeos');
    final snapshot = await ref
        .orderByChild('usuarioNombre')
        .equalTo(nombre.toLowerCase())
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((e) {
        final map = Map<String, dynamic>.from(e.value);
        map['key'] = e.key; //  guardo la key del nodo
        return map;
      }).toList();
    } else {
      return [];
    }
  }

  /// Obtiene todos los canjeos de un usuario por nombre normalizado
  Future<List<Map<String, dynamic>>> obtenerCanjeosPorNombre(
    String nombre,
  ) async {
    final ref = FirebaseDatabase.instance.ref('canjeos');
    final snapshot = await ref
        .orderByChild('usuarioNombre')
        .equalTo(nombre.toLowerCase())
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((e) => Map<String, dynamic>.from(e.value))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> marcarEntregado(String canjeoKey, bool entregado) async {
    await _service.marcarEntregado(canjeoKey, entregado);
  }

  Stream<List<RecompensaModel>> streamTodasLasRecompensas() {
    final ref = FirebaseDatabase.instance.ref(
      AppFieldsConstants.recompensasMin,
    );
    return ref.onValue.map((event) {
      final raw = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return raw.entries.map((e) {
        final id = e.key.toString();
        final data = Map<String, dynamic>.from(e.value as Map);
        return RecompensaModel.fromMap(id, data);
      }).toList();
    });
  }

  Stream<List<RecompensaModel>> streamRecompensasPara(UserModel user) {
    return streamTodasLasRecompensas().map(
      (lista) => lista.where((r) => r.usada != true).toList(),
    );
  }
}
