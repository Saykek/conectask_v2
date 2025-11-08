import 'package:firebase_database/firebase_database.dart';
import '../models/configuracion_model.dart';

class ConfiguracionController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  late ConfiguracionModel configuracion;

  Future<void> cargarConfiguracion(String uid) async {
    print('Accediendo a configuraciones/$uid');

    final snapshot = await _db.child('configuraciones/$uid').get();

    print('📦 Snapshot existe: ${snapshot.exists}');

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
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
    await _db.child('configuraciones/$uid').set(configuracion.toMap());
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
}
