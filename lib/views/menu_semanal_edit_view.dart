import 'package:conectask_v2/Utils/date_utils.dart' as miFecha;
import 'package:conectask_v2/models/comida_model.dart';
import 'package:conectask_v2/services/receta_service.dart';
import 'package:conectask_v2/widgets/autocompletar.dart';
import 'package:flutter/material.dart';
import '../controllers/menu_semanal_controller.dart';
import '../models/menu_dia_model.dart';


class MenuSemanalEditView extends StatefulWidget {
  const MenuSemanalEditView({super.key});

  @override
  State<MenuSemanalEditView> createState() => _MenuSemanalEditViewState();
}

class _MenuSemanalEditViewState extends State<MenuSemanalEditView> {
  final MenuSemanalController controller = MenuSemanalController();
  final RecetaService recetaService = RecetaService();

  List<MenuDiaModel> menu = [];
  List<ComidaModel> recetasDisponibles = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
  final datos = await controller.cargarMenuMensual(DateTime.now());
  final recetas = await recetaService.leerRecetas();

  

  setState(() {
    // Ya no recreamos con "dia", usamos directamente los objetos con fecha
    menu = datos;
    recetasDisponibles = recetas;
    cargando = false;
  });
}

@override
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;

  return Scaffold(
    appBar: AppBar(
      title: const Text('Editar Menú Semanal'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Guardar menú',
          onPressed: () async {
            await controller.guardarMenu(menu);

            for (var dia in menu) {
              if (dia.comida.nombre.isNotEmpty) {
                await recetaService.guardarReceta(dia.comida);
              }
              if (dia.cena.nombre.isNotEmpty) {
                await recetaService.guardarReceta(dia.cena);
              }
            }

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
        : isMobile
            ? _buildMobileView()
            : _buildWebView(),
  );
}
 /// Vista responsive para móvil: lista vertical
Widget _buildMobileView() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: menu.length,
    itemBuilder: (context, index) {
      final dia = menu[index];
      final fechaObj = DateTime.parse(dia.fecha);
      final nombreDia = miFecha.DateUtils.diasSemana()[fechaObj.weekday - 1];

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${miFecha.DateUtils.ponerMayuscula(nombreDia)} ${fechaObj.day}/${fechaObj.month}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // --- Comida ---
              Row(
  children: [
    Expanded(
      child: Autocompletar(
        label: "🍽️ Comida",
        initial: dia.comida.nombre,
        recetasDisponibles: recetasDisponibles,
        onChanged: (value) {
          setState(() {
            menu[index] = menu[index].copyWith(
              comida: menu[index].comida.copyWith(nombre: value),
            );
          });
        },
        onSelected: (comida) {
          setState(() {
            menu[index] = menu[index].copyWith(comida: comida);
          });
        },
      ),
    ),
    IconButton(
      icon: const Icon(Icons.link),
      tooltip: "Editar enlace receta",
      onPressed: () async {
        final controlador = TextEditingController(
          text: dia.comida.url ?? '',
        );
        final nuevaUrl = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Editar enlace de receta'),
            content: TextField(
              controller: controlador,
              decoration: const InputDecoration(hintText: 'https://...'),
              keyboardType: TextInputType.url,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final texto = controlador.text.trim();
                  Navigator.pop(context, texto);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );

        if (nuevaUrl != null) {
          setState(() {
            menu[index] = menu[index].copyWith(
              comida: menu[index].comida.copyWith(url: nuevaUrl),
            );
          });
        }
      },
    ),
    IconButton(
      icon: const Icon(Icons.photo),
      tooltip: "Añadir foto (URL)",
      onPressed: () async {
        final controlador = TextEditingController(
          text: dia.comida.foto ?? '',
        );
        final nuevaFoto = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Añadir foto de receta'),
            content: TextField(
              controller: controlador,
              decoration: const InputDecoration(hintText: 'https://...'),
              keyboardType: TextInputType.url,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final texto = controlador.text.trim();
                  Navigator.pop(context, texto);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );

        if (nuevaFoto != null) {
          setState(() {
            menu[index] = menu[index].copyWith(
              comida: menu[index].comida.copyWith(foto: nuevaFoto),
            );
          });
        }
      },
    ),
  ],
),

              const SizedBox(height: 8),

              // --- Cena ---
              IconButton(
  icon: const Icon(Icons.photo),
  tooltip: "Añadir foto (URL)",
  onPressed: () async {
    final controlador = TextEditingController(
      text: dia.cena.foto ?? '',
    );
    final nuevaFoto = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir foto de receta'),
        content: TextField(
          controller: controlador,
          decoration: const InputDecoration(hintText: 'https://...'),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final texto = controlador.text.trim();
              Navigator.pop(context, texto);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nuevaFoto != null) {
      setState(() {
        menu[index] = menu[index].copyWith(
          cena: menu[index].cena.copyWith(foto: nuevaFoto),
        );
      });
    }
  },
),
            ],
          ),
        ),
      );
    },
  );
}
  /// Vista responsive para web: tabla con días y menús
/// Vista responsive para web: tabla con días y menús
Widget _buildWebView() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: DataTable(
      columns: const [
        DataColumn(label: Text("Día")),
        DataColumn(label: Text("Comida")),
        DataColumn(label: Text("Cena")),
      ],
      rows: menu.asMap().entries.map((entry) {
        final index = entry.key;
        final dia = entry.value;
        final fechaObj = DateTime.parse(dia.fecha);
        final nombreDia = miFecha.DateUtils.diasSemana()[fechaObj.weekday - 1];

        return DataRow(cells: [
          DataCell(Text(
            "${miFecha.DateUtils.ponerMayuscula(nombreDia)} ${fechaObj.day}/${fechaObj.month}",
          )),
          DataCell(
            Row(
              children: [
                Expanded(
                  child: Autocompletar(
                    label: "🍽️",
                    initial: dia.comida.nombre,
                    recetasDisponibles: recetasDisponibles,
                    onChanged: (value) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          comida: menu[index].comida.copyWith(nombre: value),
                        );
                      });
                    },
                    onSelected: (comida) {
                      setState(() {
                        menu[index] = menu[index].copyWith(comida: comida);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.link),
                  tooltip: "Editar enlace receta",
                  onPressed: () async {
                    final controlador = TextEditingController(
                      text: dia.comida.url ?? '',
                    );
                    final nuevaUrl = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Editar enlace de receta'),
                        content: TextField(
                          controller: controlador,
                          decoration: const InputDecoration(hintText: 'https://...'),
                          keyboardType: TextInputType.url,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final texto = controlador.text.trim();
                              Navigator.pop(context, texto);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );

                    if (nuevaUrl != null) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          comida: menu[index].comida.copyWith(url: nuevaUrl),
                        );
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  tooltip: "Añadir foto (URL)",
                  onPressed: () async {
                    final controlador = TextEditingController(
                      text: dia.comida.foto ?? '',
                    );
                    final nuevaFoto = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Añadir foto de receta'),
                        content: TextField(
                          controller: controlador,
                          decoration: const InputDecoration(hintText: 'https://...'),
                          keyboardType: TextInputType.url,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final texto = controlador.text.trim();
                              Navigator.pop(context, texto);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );

                    if (nuevaFoto != null) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          comida: menu[index].comida.copyWith(foto: nuevaFoto),
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Expanded(
                  child: Autocompletar(
                    label: "🌙",
                    initial: dia.cena.nombre,
                    recetasDisponibles: recetasDisponibles,
                    onChanged: (value) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          cena: menu[index].cena.copyWith(nombre: value),
                        );
                      });
                    },
                    onSelected: (comida) {
                      setState(() {
                        menu[index] = menu[index].copyWith(cena: comida);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.link),
                  tooltip: "Editar enlace receta",
                  onPressed: () async {
                    final controlador = TextEditingController(
                      text: dia.cena.url ?? '',
                    );
                    final nuevaUrl = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Editar enlace de receta'),
                        content: TextField(
                          controller: controlador,
                          decoration: const InputDecoration(hintText: 'https://...'),
                          keyboardType: TextInputType.url,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final texto = controlador.text.trim();
                              Navigator.pop(context, texto);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );

                    if (nuevaUrl != null) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          cena: menu[index].cena.copyWith(url: nuevaUrl),
                        );
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  tooltip: "Añadir foto (URL)",
                  onPressed: () async {
                    final controlador = TextEditingController(
                      text: dia.cena.foto ?? '',
                    );
                    final nuevaFoto = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Añadir foto de receta'),
                        content: TextField(
                          controller: controlador,
                          decoration: const InputDecoration(hintText: 'https://...'),
                          keyboardType: TextInputType.url,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final texto = controlador.text.trim();
                              Navigator.pop(context, texto);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );

                    if (nuevaFoto != null) {
                      setState(() {
                        menu[index] = menu[index].copyWith(
                          cena: menu[index].cena.copyWith(foto: nuevaFoto),
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ]);
      }).toList(),
    ),
  );
}
}
