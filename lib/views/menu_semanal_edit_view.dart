import 'package:conectask_v2/models/comida_model.dart';
import 'package:conectask_v2/services/receta_service.dart';
import 'package:conectask_v2/widgets/autocompletar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final datos = await controller.cargarMenu();
    final recetas = await recetaService.leerRecetas();

    setState(() {
      menu = datos.map((d) => MenuDiaModel(dia: d.dia)).toList();
      recetasDisponibles = recetas;
      cargando = false;
      final Set<int> mostrarCampoComida = {};
      final Set<int> mostrarCampoCena = {};
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

              // Guardar también los platos nuevos en el catálogo de recetas
              for (var dia in menu) {
                if (dia.comida != null) {
                  await recetaService.guardarReceta(dia.comida!);
                }
                if (dia.cena != null) {
                  await recetaService.guardarReceta(dia.cena!);
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
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextUtils.ponerMayuscula(dia.dia),
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
                            dia.comida = dia.comida.copyWith(nombre: value);
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            dia.comida = comida;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Copiar enlace",
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
                              decoration: const InputDecoration(
                                hintText: 'https://...',
                              ),
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
                            dia.comida = dia.comida.copyWith(url: nuevaUrl);
                          });
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // --- Cena ---
                Row(
                  children: [
                    Expanded(
                      child: Autocompletar(
                        label: "🌙 Cena",
                        initial: dia.cena.nombre,
                        recetasDisponibles: recetasDisponibles,
                        onChanged: (value) {
                          setState(() {
                            dia.cena = dia.cena.copyWith(nombre: value);
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            dia.cena = comida;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Copiar enlace",
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
                              decoration: const InputDecoration(
                                hintText: 'https://...',
                              ),
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
                            dia.cena = dia.cena.copyWith(url: nuevaUrl);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Vista responsive para web/escritorio: tabla completa
  Widget _buildWebView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text('Día')),
          DataColumn(label: Text('Comida')),
          DataColumn(label: Text('Cena')),
        ],
        rows: menu.map((dia) {
          return DataRow(
            cells: [
              DataCell(Text(TextUtils.ponerMayuscula(dia.dia))),

              // --- Comida ---
              DataCell(
                Row(
                  children: [
                    Expanded(
                      child: Autocompletar(
                        label: "Comida",
                        initial: dia.comida.nombre,
                        recetasDisponibles: recetasDisponibles,
                        onChanged: (value) {
                          setState(() {
                            dia.comida = dia.comida.copyWith(nombre: value);
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            dia.comida = comida;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Copiar enlace",
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
                              decoration: const InputDecoration(
                                hintText: 'https://...',
                              ),
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
                            dia.comida = dia.comida.copyWith(url: nuevaUrl);
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      tooltip: "Editar imagen",
                      onPressed: () async {
                        final controlador = TextEditingController(
                          text: dia.comida.foto ?? '',
                        );

                        final nuevaUrl = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Editar imagen de receta'),
                            content: TextField(
                              controller: controlador,
                              decoration: const InputDecoration(
                                hintText: 'https://imagen.jpg',
                              ),
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
                            dia.comida = dia.comida.copyWith(foto: nuevaUrl);
                          });

                          await recetaService.guardarReceta(dia.comida);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // --- Cena ---
              DataCell(
                Row(
                  children: [
                    Expanded(
                      child: Autocompletar(
                        label: "Cena",
                        initial: dia.cena.nombre,
                        recetasDisponibles: recetasDisponibles,
                        onChanged: (value) {
                          setState(() {
                            dia.cena = dia.cena.copyWith(nombre: value);
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            dia.cena = comida;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Copiar enlace",
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
                              decoration: const InputDecoration(
                                hintText: 'https://...',
                              ),
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
                            dia.cena = dia.cena.copyWith(url: nuevaUrl);
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      tooltip: "Editar imagen",
                      onPressed: () async {
                        final controlador = TextEditingController(
                          text: dia.cena.foto ?? '',
                        );

                        final nuevaUrl = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Editar imagen de receta'),
                            content: TextField(
                              controller: controlador,
                              decoration: const InputDecoration(
                                hintText: 'https://imagen.jpg',
                              ),
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
                            dia.cena = dia.cena.copyWith(foto: nuevaUrl);
                          });

                          await recetaService.guardarReceta(dia.cena);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
