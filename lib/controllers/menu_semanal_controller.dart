import 'package:conectask_v2/Utils/date_utils.dart' as miFecha;
import '../models/menu_dia_model.dart';
import '../services/menu_semanal_service.dart';

class MenuSemanalController {
  final MenuSemanalService _service = MenuSemanalService();

  Future<List<MenuDiaModel>> cargarMenu() async {
    final datos = await _service.leerMenu();

    final diasSemana = miFecha.DateUtils.diasSemana();

    // Combinar datos existentes con los días faltantes
    final menuCompleto = diasSemana.map((dia) {
      final existente = datos.firstWhere(
        (d) => d.dia == dia,
        orElse: () => MenuDiaModel(dia: dia),
      );
      return existente;
    }).toList();

    return menuCompleto;
  }

  Future<void> guardarMenu(List<MenuDiaModel> menu) async {
    final data = {for (var dia in menu) dia.dia: dia.toMap()};
    await _service.guardarMenu(data);
  }
}
