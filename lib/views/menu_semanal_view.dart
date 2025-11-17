import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/menu_semanal_edit_view.dart';
import 'package:conectask_v2/utils/date_utils.dart' as miFecha;
import 'package:conectask_v2/widgets/menu_card.dart';
import 'package:conectask_v2/widgets/tira_dias.dart';
import 'package:flutter/material.dart';

class MenuSemanalView extends StatefulWidget {
  final Map<String, Map<String, dynamic>> menu; 
  // ej: {'lunes': {'comida': {...}, 'cena': {...}}}
  final UserModel user;

  const MenuSemanalView({super.key, required this.menu, required this.user});

  @override
  State<MenuSemanalView> createState() => _MenuSemanalViewState();
}

class _MenuSemanalViewState extends State<MenuSemanalView> {
  late List<String> dias = miFecha.DateUtils.diasSemana();
  late List<int> numerosSemana = _calcularNumerosSemanaActual();
  late String diaSeleccionado;

  @override
  void initState() {
    super.initState();
    dias = miFecha.DateUtils.diasSemana();
    numerosSemana = _calcularNumerosSemanaActual();

    // Día actual en español desde tus utils
    final hoy = miFecha.DateUtils.diaActual();

    // Selección inicial: hoy si existe; si no, el primer día que exista; si no, el primero de la lista
    if (widget.menu.containsKey(hoy)) {
      diaSeleccionado = hoy;
    } else {
      diaSeleccionado = dias.firstWhere(
        (d) => widget.menu.containsKey(d),
        orElse: () => dias.first,
      );
    }
  }

  /// Calcula los números del mes para la semana actual (lunes a domingo).
  List<int> _calcularNumerosSemanaActual() {
    final hoy = DateTime.now();
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1)); // lunes
    return List.generate(7, (i) => inicioSemana.add(Duration(days: i)).day);
  }

  @override
  Widget build(BuildContext context) {
    final MenuDiaModel diaModel = MenuDiaModel.fromMap(
      diaSeleccionado,
      widget.menu[diaSeleccionado],
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
          // Tira horizontal de días estilo calendario
          TiraDiasWidget(
            dias: dias,
            numeros: numerosSemana,
            diaSeleccionado: diaSeleccionado,
            onSelectDia: (nuevoDia) {
              setState(() {
                diaSeleccionado = nuevoDia;
              });
            },
          ),
          const SizedBox(height: 16),
          // Tarjetas de comida y cena
          Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text("Comida", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      MenuCard(comida: diaModel.comida),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text("Cena", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      MenuCard(comida: diaModel.cena),
    ],
  ),
),
        ],
      ),
    );
  }
}