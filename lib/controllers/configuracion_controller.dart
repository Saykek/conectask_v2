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
}
