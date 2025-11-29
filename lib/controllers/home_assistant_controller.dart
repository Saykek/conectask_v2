import '../services/home_assistant_service.dart';

class HomeAssistantController {
  final HomeAssistantService service;

  HomeAssistantController(this.service);

  /// Devuelve la URL de Lovelace lista para abrir en WebView
  String obtenerUrlLovelace() {
    return service.getLovelaceUrl();
  }

  /// Comprueba si el usuario puede acceder al módulo
  bool puedeAcceder(String rolUsuario) {
    return service.puedeMostrar(rolUsuario);
  }
}
