import 'package:conectask_v2/common/constants/constant.dart';

import '../models/home_assistant_model.dart';

class HomeAssistantService {
  final HomeAssistantModel model;

  HomeAssistantService(this.model);

  /// Devuelve la URL lista para abrir en WebView
  String getLovelaceUrl() {
    return model.lovelaceUrl;
  }

  /// Comprueba si el módulo debe mostrarse solo a admin
  bool puedeMostrar(String rolUsuario) {
    if (model.soloAdmin && rolUsuario != AppConstants.rolAdmin) {
      return false;
    }
    return true;
  }
}