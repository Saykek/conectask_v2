import 'package:conectask_v2/controllers/menu_semanal_controller.dart';
import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:conectask_v2/views/menu_semanal_detalle_view.dart';
import 'package:conectask_v2/views/menu_semanal_edit_view.dart';
import 'package:conectask_v2/common/widgets/menu_card.dart';
import 'package:conectask_v2/common/widgets/tira_dias.dart';
import 'package:flutter/material.dart';
import 'package:conectask_v2/common/utils/date_utils.dart' as miFecha;
import '../common/constants/constant.dart';

class MenuSemanalView extends StatefulWidget {
  final Map<String, dynamic> menu;
  final dynamic user;

  const MenuSemanalView({super.key, required this.menu, required this.user});

  @override
  State<MenuSemanalView> createState() => _MenuSemanalViewState();
}

class _MenuSemanalViewState extends State<MenuSemanalView> {
  final MenuSemanalController controller = MenuSemanalController();
  List<MenuDiaModel> menu = [];
  bool cargando = true;
  late List<DateTime> fechasMes;
  late DateTime diaSeleccionado;

  @override
  void initState() {
    super.initState();
    // Genera todos los días del mes actual
    fechasMes = miFecha.DateUtils.diasDelMes(
      DateTime.now(),
    ).map((d) => d['fecha'] as DateTime).toList();
    // Selección inicial: el día actual
    diaSeleccionado = DateTime.now();

    cargarDatos();
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<void> cargarDatos() async {
    final datos = await controller.cargarMenuMensual(DateTime.now());
    setState(() {
      menu = datos;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fecha seleccionada en formato yyyy-MM-dd
    final fechaStr = _formatearFecha(diaSeleccionado);

    // Nombre del día en español (para mostrar)
    final nombreDia =
        miFecha.DateUtils.diasSemana()[diaSeleccionado.weekday - 1];

    // Buscar el día en la lista actualizada (menu), NO en widget.menu
    final diaModel = menu.firstWhere(
      (d) => d.fecha == fechaStr,
      orElse: () => MenuDiaModel(fecha: fechaStr),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppFieldsConstants.menuSemanal),
        actions: [
          if (widget.user.rol == AppConstants.rolAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: AppFieldsConstants.toolEditarMenu,
              onPressed: () async {
                final actualizado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MenuSemanalEditView(),
                  ),
                );

                if (actualizado == true) {
                  //  recarga los datos al volver
                  await cargarDatos();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          //  Scroll horizontal de días
          TiraDiasWidget(
            fechas: fechasMes,
            diaSeleccionado: diaSeleccionado,
            onSelectDia: (nuevoDia) {
              setState(() {
                diaSeleccionado = nuevoDia;
              });
            },
          ),

          // Día seleccionado en grande
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 30),
                  onPressed: () {
                    setState(() {
                      diaSeleccionado = diaSeleccionado.subtract(
                        const Duration(days: 1),
                      );
                    });
                  },
                ),

                Text(
                  "${miFecha.DateUtils.ponerMayuscula(nombreDia)} ${diaSeleccionado.day}/${diaSeleccionado.month}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.arrow_right, size: 30),
                  onPressed: () {
                    setState(() {
                      diaSeleccionado = diaSeleccionado.add(
                        const Duration(days: 1),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          //Padding(
          //padding: const EdgeInsets.symmetric(vertical: 12),
          //child: Text(
          // "${miFecha.DateUtils.ponerMayuscula(nombreDia)} ${diaSeleccionado.day}/${diaSeleccionado.month}",
          // style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          // ),
          // ),
          const SizedBox(height: 16),

          //  dos platos en comida y dos en cena
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      AppFieldsConstants.comida,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...diaModel.comidas.asMap().entries.map((entry) {
                    final comida = entry.value;
                    return MenuCard(
                      comida: comida,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuSemanalDetalleView(
                              fecha: fechaStr,
                              comida: comida,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      AppFieldsConstants.cena,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...diaModel.cenas.asMap().entries.map((entry) {
                    final cena = entry.value;
                    return MenuCard(
                      comida: cena,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuSemanalDetalleView(
                              fecha: fechaStr,
                              comida: cena,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
