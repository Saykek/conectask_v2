import 'package:conectask_v2/models/comida_model.dart';
import 'package:flutter/material.dart';
import '../controllers/menu_semanal_controller.dart';
import '../models/menu_dia_model.dart';
import 'package:conectask_v2/Utils/text_utils.dart';

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

    // Crear menú vacío con los mismos días
    setState(() {
      menu = datos.map((d) => MenuDiaModel(dia: d.dia)).toList();
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
                      DataCell(Text(TextUtils.ponerMayuscula(dia.dia))),
                      DataCell(
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return comidasDisponibles.where(
                              (comida) => comida.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                            );
                          },
                          onSelected: (String seleccion) {
                            setState(
                              () =>
                                  dia.almuerzo = ComidaModel(nombre: seleccion),
                            );
                          },
                          fieldViewBuilder:
                              (
                                context,
                                textController,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                return TextField(
                                  controller: textController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe o selecciona',
                                  ),
                                  onChanged: (value) {
                                    dia.almuerzo = ComidaModel(nombre: value);
                                  },
                                );
                              },
                        ),
                      ),
                      DataCell(
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return comidasDisponibles.where(
                              (comida) => comida.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                            );
                          },
                          onSelected: (String seleccion) {
                            setState(
                              () => dia.cena = ComidaModel(nombre: seleccion),
                            );
                          },
                          fieldViewBuilder:
                              (
                                context,
                                textController,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                return TextField(
                                  controller: textController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe o selecciona',
                                  ),
                                  onChanged: (value) {
                                    dia.cena = ComidaModel(nombre: value);
                                  },
                                );
                              },
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
