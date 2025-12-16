import 'package:conectask_v2/common/constants/constant.dart';

class ConfiguracionModel {
  String tema;
  String idioma;
  String rol;
  bool notificacionesActivas;
  String urlServidor;

  ConfiguracionModel({
    required this.tema,
    required this.idioma,
    required this.rol,
    required this.notificacionesActivas,
    required this.urlServidor,
  });

  factory ConfiguracionModel.fromMap(Map<String, dynamic> map) {
    return ConfiguracionModel(
      tema: map[AppConstants.tema] ?? AppConstants.claro,
      idioma: map[AppConstants.idioma] ?? AppConstants.idiomaEs,
      rol: map[AppConstants.rol] ?? AppConstants.rolNino,
      notificacionesActivas: map[AppConstants.notificacionesActivas] ?? true,
      urlServidor: map[AppConstants.urlServidor] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.tema: tema,
      AppConstants.idioma: idioma,
      AppConstants.rol: rol,
      AppConstants.notificacionesActivas: notificacionesActivas,
      AppConstants.urlServidor: urlServidor,
    };
  }
}
