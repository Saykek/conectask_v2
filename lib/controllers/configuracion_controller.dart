import 'package:conectask_v2/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/configuracion_model.dart';
import '../services/configuracion_service.dart';

class ConfiguracionController {
  final ConfiguracionService _service = ConfiguracionService();
  late ConfiguracionModel configuracion;

  Future<void> cargarConfiguracion(String uid) async {
    final data = await _service.leerConfiguracion(uid);

    if (data != null) {
      configuracion = ConfiguracionModel.fromMap(data);
    } else {
      configuracion = ConfiguracionModel(
        tema: 'claro',
        idioma: 'es',
        rol: 'niño',
        notificacionesActivas: true,
        urlServidor: '',
      );
      await guardarConfiguracion(uid);
    }
  }

  Future<void> guardarConfiguracion(String uid) async {
    await _service.guardarConfiguracion(uid, configuracion.toMap());
  }

  void actualizarCampo(String campo, dynamic valor) {
    switch (campo) {
      case 'tema':
        configuracion.tema = valor;
        break;
      case 'idioma':
        configuracion.idioma = valor;
        break;
      case 'rol':
        configuracion.rol = valor;
        break;
      case 'notificacionesActivas':
        configuracion.notificacionesActivas = valor;
        break;
      case 'urlServidor':
        configuracion.urlServidor = valor;
        break;
    }
  }

  Future<List<UserModel>> cargarNinos() async {
    final ref = FirebaseDatabase.instance.ref('usuarios');
    final snapshot = await ref.get();

    final List<UserModel> ninos = [];

    if (snapshot.exists && snapshot.value != null) {
      final rawData = snapshot.value;

      if (rawData is Map<dynamic, dynamic>) {
        rawData.forEach((key, value) {
          if (value is Map) {
            final userMap = Map<String, dynamic>.from(value);
            final user = UserModel.fromMap(key, userMap);
            if (user.rol == 'niño') {
              ninos.add(user);
            }
          }
        });
      }
    }

    return ninos;
  }
}