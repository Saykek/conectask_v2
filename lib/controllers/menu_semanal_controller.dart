import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:conectask_v2/services/menu_semanal_service.dart';

class MenuSemanalController {
  final MenuSemanalService _service = MenuSemanalService();

  /// Leer todos los menús directamente desde Firebase
  Future<List<MenuDiaModel>> leerMenu() async {
    return await _service.leerMenu();
  }

  /// Cargar el menú de un mes completo
  Future<List<MenuDiaModel>> cargarMenuMensual(DateTime mes) async {
    final datos = await _service.leerMenu();

    // Generar todas las fechas del mes actual
    final primerDia = DateTime(mes.year, mes.month, 1);
    final ultimoDia = DateTime(mes.year, mes.month + 1, 0);

    final List<MenuDiaModel> menuCompleto = [];

    for (int i = 0; i < ultimoDia.day; i++) {
      final fecha = primerDia.add(Duration(days: i));
      final fechaStr =
          "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

      // Buscar si ya existe en Firebase, si no crear vacío
      final existente = datos.firstWhere(
        (d) => d.fecha == fechaStr,
        orElse: () => MenuDiaModel(fecha: fechaStr),
      );

      menuCompleto.add(existente);
    }

    return menuCompleto;
  }

  /// Guardar un mes completo
  Future<void> guardarMenu(List<MenuDiaModel> menu) async {
    final data = {for (var dia in menu) dia.fecha: dia.toMap()};
    await _service.guardarMenu(data);
  }

  /// Guardar un único día
  Future<void> guardarMenuDia(MenuDiaModel menuDia) async {
    await _service.guardarMenuDia(menuDia);
  }

  /// Leer un único día
  Future<MenuDiaModel?> leerMenuDia(DateTime fecha) async {
    final fechaStr =
        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
    return await _service.leerMenuDia(fechaStr);
  }
}
