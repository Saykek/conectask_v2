import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:conectask_v2/views/menu_semanal_detalle_view.dart';
import 'package:conectask_v2/views/menu_semanal_edit_view.dart';
import 'package:conectask_v2/widgets/menu_card.dart';
import 'package:conectask_v2/widgets/tira_dias.dart';
import 'package:flutter/material.dart';
import 'package:conectask_v2/utils/date_utils.dart' as miFecha;


class MenuSemanalView extends StatefulWidget {
  final Map<String, dynamic> menu;
  final dynamic user;

  const MenuSemanalView({super.key, required this.menu, required this.user});

  @override
  State<MenuSemanalView> createState() => _MenuSemanalViewState();
}

class _MenuSemanalViewState extends State<MenuSemanalView> {
  late List<DateTime> fechasMes;
  late DateTime diaSeleccionado;

  @override
  void initState() {
    super.initState();
    // Genera todos los días del mes actual
    fechasMes = miFecha.DateUtils.diasDelMes(DateTime.now())
        .map((d) => d['fecha'] as DateTime)
        .toList();
    // Selección inicial: el día actual
    diaSeleccionado = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Nombre del día en español
    final nombreDia =
        miFecha.DateUtils.diasSemana()[diaSeleccionado.weekday - 1];

    // Modelo del día
    final MenuDiaModel diaModel = MenuDiaModel.fromMap(
      nombreDia,
      widget.menu[nombreDia],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Semanal'),
        actions: [
          if (widget.user.rol == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Editar menú semanal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MenuSemanalEditView(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Tira horizontal de días
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
            child: Text(
              miFecha.DateUtils.ponerMayuscula(
                miFecha.DateUtils.diasSemana()[diaSeleccionado.weekday - 1],
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // Tarjetas de comida y cena
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text("Comida",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                MenuCard(
                  comida: diaModel.comida,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuSemanalDetalleView(
                          nombreDia: nombreDia,
                          comida: diaModel.comida,
                        ),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text("Cena",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                MenuCard(
                  comida: diaModel.cena,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuSemanalDetalleView(
                          nombreDia: nombreDia,
                          comida: diaModel.cena,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}