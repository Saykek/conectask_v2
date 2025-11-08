import 'package:conectask_v2/controllers/menu_semanal_controller.dart';
import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:flutter/material.dart';

class MenuSemanalEditView extends StatefulWidget {
  const MenuSemanalEditView({super.key});

  @override
  State<MenuSemanalEditView> createState() => _MenuSemanalEditViewState();
}

class _MenuSemanalEditViewState extends State<MenuSemanalEditView> {
  final MenuSemanalController controller = MenuSemanalController();
  final List<String> comidasDisponibles = [
    'Macarrones',
    'Sopa',
    'Arroz',
    'Tortilla',
    'Pizza',
    'Ensalada',
    'Pollo',
    'Pescado',
    'Verduras',
    'Lentejas',
  ];

  List<MenuDiaModel> menu = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final datos = await controller.cargarMenu();
    setState(() {
      menu = datos.isNotEmpty
          ? datos
          : [
              'lunes',
              'martes',
              'miércoles',
              'jueves',
              'viernes',
              'sábado',
              'domingo',
            ].map((d) => MenuDiaModel(dia: d)).toList();
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Menú Semanal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar menú',
            onPressed: () async {
              print(menu.map((d) => d.toMap()).toList());

              await controller.guardarMenu(menu);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menú guardado correctamente')),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Día')),
                  DataColumn(label: Text('Almuerzo')),
                  DataColumn(label: Text('Cena')),
                ],
                rows: menu.map((dia) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(dia.dia[0].toUpperCase() + dia.dia.substring(1)),
                      ),
                      DataCell(
                        DropdownButton<String>(
                          value: dia.almuerzo.isNotEmpty ? dia.almuerzo : null,
                          hint: const Text('Seleccionar'),
                          items: comidasDisponibles
                              .map(
                                (comida) => DropdownMenuItem(
                                  value: comida,
                                  child: Text(comida),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => dia.almuerzo = value ?? ''),
                        ),
                      ),
                      DataCell(
                        DropdownButton<String>(
                          value: dia.cena.isNotEmpty ? dia.cena : null,
                          hint: const Text('Seleccionar'),
                          items: comidasDisponibles
                              .map(
                                (comida) => DropdownMenuItem(
                                  value: comida,
                                  child: Text(comida),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => dia.cena = value ?? ''),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
