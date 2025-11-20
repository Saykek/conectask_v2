class HomeAssistantModel {
  final String baseUrl;       // URL de tu instancia HA ( http://192.168.1.100:8123)
  final String accessToken;   // Token largo para login automático
  final String panel;         // Panel Lovelace 
  final bool soloAdmin;       // Si solo los admin pueden ver este módulo

  HomeAssistantModel({
    required this.baseUrl,
    required this.accessToken,
    this.panel = "default",
    this.soloAdmin = true,
  });

  /// Devuelve la URL completa para abrir el panel Lovelace con token
  String get lovelaceUrl {
    return "$baseUrl/lovelace/$panel?auth_token=$accessToken";
  }
}