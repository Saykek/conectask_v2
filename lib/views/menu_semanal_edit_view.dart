import 'package:conectask_v2/Utils/date_utils.dart' as miFecha;
import 'package:conectask_v2/models/comida_model.dart';
import 'package:conectask_v2/services/receta_service.dart';
import 'package:conectask_v2/widgets/autocompletar.dart';
import 'package:conectask_v2/widgets/tira_dias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/menu_semanal_controller.dart';
import '../models/menu_dia_model.dart';


class MenuSemanalEditView extends StatefulWidget {
  const MenuSemanalEditView({super.key});

  @override
  State<MenuSemanalEditView> createState() => _MenuSemanalEditViewState();
}

class _MenuSemanalEditViewState extends State<MenuSemanalEditView> with RouteAware {

  final MenuSemanalController controller = MenuSemanalController();
  final RecetaService recetaService = RecetaService();
  final ScrollController _scrollController = ScrollController();


  List<MenuDiaModel> menu = [];
  List<ComidaModel> recetasDisponibles = [];
  bool cargando = true;

  // Tira de días (mes completo) + día seleccionado
  late List<DateTime> fechasMes;
  DateTime diaSeleccionado = DateTime.now();

   @override
  void didPopNext() {
    // 👇 Se llama cuando vuelves a esta pantalla
    cargarDatos();
  }


  @override
void initState() {
  super.initState();
  // Genera todos los días del mes actual
  fechasMes = miFecha.DateUtils.diasDelMes(DateTime.now())
      .map((d) => d['fecha'] as DateTime)
      .toList();
  // Selección inicial: el día actual
  diaSeleccionado = DateTime.now();

  // 👇 Cargar datos al iniciar
  cargarDatos();
}

  Future<void> cargarDatos() async {
    final datos = await controller.cargarMenuMensual(DateTime.now());
    final recetas = await recetaService.leerRecetas();

    setState(() {
      menu = datos;                 // lista completa del mes
      recetasDisponibles = recetas; // recetas para autocompletar
      cargando = false;
    });
   // Mover scroll al día actual después de que se construya la vista
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final hoyStr = miFecha.DateUtils.formatearFecha(DateTime.now());
    final idxHoy = menu.indexWhere((d) => d.fecha == hoyStr);
    if (idxHoy >= 0) {
      // Ajusta el factor según la altura aproximada de cada fila
      final offset = idxHoy * 100.0;
      _scrollController.jumpTo(offset);
    }
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
    try {
      // Guardar todo el menú del mes
      await controller.guardarMenu(menu);

      // Guardar recetas nuevas
      for (final dia in menu) {
        for (final plato in dia.comidas) {
          if (plato.nombre.isNotEmpty) {
            await recetaService.guardarReceta(plato);
          }
        }
        for (final plato in dia.cenas) {
          if (plato.nombre.isNotEmpty) {
            await recetaService.guardarReceta(plato);
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menú guardado correctamente')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar menú: $e')),
        );
      }
    }
  },
),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tira superior: mes completo (si cabe, verás el siguiente al hacer scroll)
                TiraDiasWidget(
                  fechas: fechasMes,
                  diaSeleccionado: diaSeleccionado,
                  onSelectDia: (nuevoDia) {
                    setState(() {
                      diaSeleccionado = nuevoDia;
                    });
                  final idxSel = miFecha.DateUtils.buscarIndiceDia(menu, nuevoDia);

    if (idxSel >= 0) {
      // Estimación de altura de cada fila/card
      //  Ajustar diseño:
      // - Móvil: ~100 px por card
      // - Web: ~100 px por fila de DataTable
      final offset = idxSel * 115.0;

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  },
),


                // Encabezado con el día seleccionado (solo informativo, no filtra el listado)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${miFecha.DateUtils.ponerMayuscula(miFecha.DateUtils.diasSemana()[diaSeleccionado.weekday - 1])} ${diaSeleccionado.day}/${diaSeleccionado.month}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                // Debajo: listado de edición con autocompletado
                Expanded(
                  child: isMobile ? _buildMobileView() : _buildWebView(),
                ),
              ],
            ),
    );
  }

  /// Vista móvil: lista vertical limitada a 10 días
  Widget _buildMobileView() {
  // Buscar índice del día actual
  final hoyStr = miFecha.DateUtils.formatearFecha(DateTime.now());
  final startIndex = menu.indexWhere((d) => d.fecha == hoyStr);
  final safeStart = startIndex >= 0 ? startIndex : 0;

  // Lista visible: 10 días desde hoy
  final visibles = menu.skip(safeStart).take(10).toList();

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: visibles.length,
    itemBuilder: (context, index) {
      final dia = visibles[index];
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

              // --- Comida: dos platos ---
              for (int i = 0; i < dia.comidas.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: Autocompletar(
                        label: "🍽️ Comida ${i + 1}",
                        initial: dia.comidas[i].nombre,
                        recetasDisponibles: recetasDisponibles,
                        onChanged: (value) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              comidas: List.from(visibles[index].comidas)
                                ..[i] = visibles[index].comidas[i].copyWith(nombre: value),
                            );
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              comidas: List.from(visibles[index].comidas)..[i] = comida,
                            );
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Editar enlace receta",
                      onPressed: () async {
                        final controlador = TextEditingController(text: dia.comidas[i].url ?? '');
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
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                            ],
                          ),
                        );
                        if (nuevaUrl != null) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              comidas: List.from(visibles[index].comidas)
                                ..[i] = visibles[index].comidas[i].copyWith(url: nuevaUrl),
                            );
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      tooltip: "Añadir foto (URL)",
                      onPressed: () async {
                        final controlador = TextEditingController(text: dia.comidas[i].foto ?? '');
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
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                            ],
                          ),
                        );
                        if (nuevaFoto != null) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              comidas: List.from(visibles[index].comidas)
                                ..[i] = visibles[index].comidas[i].copyWith(foto: nuevaFoto),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // --- Cena: dos platos ---
              for (int i = 0; i < dia.cenas.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: Autocompletar(
                        label: "🌙 Cena ${i + 1}",
                        initial: dia.cenas[i].nombre,
                        recetasDisponibles: recetasDisponibles,
                        onChanged: (value) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              cenas: List.from(visibles[index].cenas)
                                ..[i] = visibles[index].cenas[i].copyWith(nombre: value),
                            );
                          });
                        },
                        onSelected: (comida) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              cenas: List.from(visibles[index].cenas)..[i] = comida,
                            );
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Editar enlace receta",
                      onPressed: () async {
                        final controlador = TextEditingController(text: dia.cenas[i].url ?? '');
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
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                            ],
                          ),
                        );
                        if (nuevaUrl != null) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              cenas: List.from(visibles[index].cenas)
                                ..[i] = visibles[index].cenas[i].copyWith(url: nuevaUrl),
                            );
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      tooltip: "Añadir foto (URL)",
                      onPressed: () async {
                        final controlador = TextEditingController(text: dia.cenas[i].foto ?? '');
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
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                            ],
                          ),
                        );
                        if (nuevaFoto != null) {
                          setState(() {
                            visibles[index] = visibles[index].copyWith(
                              cenas: List.from(visibles[index].cenas)
                                ..[i] = visibles[index].cenas[i].copyWith(foto: nuevaFoto),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      );
    },
  );
}

  /// Vista web:
  Widget _buildWebView() {
  // Formatear fechas
  final hoyStr = miFecha.DateUtils.formatearFecha(DateTime.now());
  final selStr = miFecha.DateUtils.formatearFecha(diaSeleccionado);

  // Buscar índices en el menú
  final idxHoy = menu.indexWhere((d) => d.fecha == hoyStr);
  final idxSel = menu.indexWhere((d) => d.fecha == selStr);

  // Elegir inicio: hoy -> seleccionado -> 0
  final safeStart = idxHoy >= 0 ? idxHoy : (idxSel >= 0 ? idxSel : 0);

  // Mostrar todo el mes 
  final visibles = menu;

  return SingleChildScrollView(
    controller: _scrollController,
    padding: const EdgeInsets.all(16),
    child: DataTable(
      dataRowMinHeight: 90,
      dataRowMaxHeight: 115,
      columns: const [
        DataColumn(label: Text("Día")),
        DataColumn(label: Text("Comidas")), // Comida 1 arriba, Comida 2 debajo
        DataColumn(label: Text("Cenas")),   // Cena 1 arriba, Cena 2 debajo
      ],
      rows: visibles.asMap().entries.map((entry) {
        final index = entry.key;
        final dia = entry.value;
        final realIdx = index;
        final fechaObj = DateTime.parse(dia.fecha);
        final nombreDia = miFecha.DateUtils.diasSemana()[fechaObj.weekday - 1];

        return DataRow(cells: [
          DataCell(Text(
            "${miFecha.DateUtils.ponerMayuscula(nombreDia)} ${fechaObj.day}/${fechaObj.month}",
          )),

          // Comidas (apiladas)
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1er Plato (Comida 1)
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: Text("1er plato"),
                  ),
                  Expanded(
                    child: Autocompletar(
                      label: "🍽️",
                      initial: dia.comidas[0].nombre,
                      recetasDisponibles: recetasDisponibles,
                      onChanged: (value) {
  if (realIdx >= menu.length) {
    debugPrint("⚠️ Índice fuera de rango: $realIdx (menu.length=${menu.length})");
    return;
  }

  setState(() {
    final comidas = List<ComidaModel>.from(menu[realIdx].comidas);
    comidas[0] = comidas[0].copyWith(nombre: value);

    menu[realIdx] = menu[realIdx].copyWith(comidas: comidas);
  });
},
                      onSelected: (comida) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)..[0] = comida,
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: "Editar enlace receta",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.comidas[0].url ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaUrl != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)
                              ..[0] = menu[realIdx].comidas[0].copyWith(url: nuevaUrl),
                          );
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    tooltip: "Añadir foto (URL)",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.comidas[0].foto ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaFoto != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)
                              ..[0] = menu[realIdx].comidas[0].copyWith(foto: nuevaFoto),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 2º Plato (Comida 2)
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: Text("2º plato"),
                  ),
                  Expanded(
                    child: Autocompletar(
                      label: "🍽️",
                      initial: dia.comidas[1].nombre,
                      recetasDisponibles: recetasDisponibles,
                      onChanged: (value) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)
                              ..[1] = menu[realIdx].comidas[1].copyWith(nombre: value),
                          );
                        });
                      },
                      onSelected: (comida) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)..[1] = comida,
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: "Editar enlace receta",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.comidas[1].url ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaUrl != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)
                              ..[1] = menu[realIdx].comidas[1].copyWith(url: nuevaUrl),
                          );
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    tooltip: "Añadir foto (URL)",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.comidas[1].foto ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaFoto != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            comidas: List.from(menu[realIdx].comidas)
                              ..[1] = menu[realIdx].comidas[1].copyWith(foto: nuevaFoto),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          )),

          // Cenas (apiladas)
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cena 1
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: Text("1er plato"),
                  ),
                  Expanded(
                    child: Autocompletar(
                      label: "🌙",
                      initial: dia.cenas[0].nombre,
                      recetasDisponibles: recetasDisponibles,
                      onChanged: (value) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[0] = menu[realIdx].cenas[0].copyWith(nombre: value),
                          );
                        });
                      },
                      onSelected: (comida) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)..[0] = comida,
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: "Editar enlace receta",
                    onPressed: () async {
                      
                      final controlador = TextEditingController(text: dia.cenas[0].url ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaUrl != null) {
                        setState(() {
                          
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[0] = menu[realIdx].cenas[0].copyWith(url: nuevaUrl),
                          );
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    tooltip: "Añadir foto (URL)",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.cenas[0].foto ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaFoto != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[0] = menu[realIdx].cenas[0].copyWith(foto: nuevaFoto),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Cena 2
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: Text("2º plato"),
                  ),
                  Expanded(
                    child: Autocompletar(
                      label: "🌙",
                      initial: dia.cenas[1].nombre,
                      recetasDisponibles: recetasDisponibles,
                      onChanged: (value) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[1] = menu[realIdx].cenas[1].copyWith(nombre: value),
                          );
                        });
                      },
                      onSelected: (comida) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)..[1] = comida,
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: "Editar enlace receta",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.cenas[1].url ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaUrl != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[1] = menu[realIdx].cenas[1].copyWith(url: nuevaUrl),
                          );
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    tooltip: "Añadir foto (URL)",
                    onPressed: () async {
                      final controlador = TextEditingController(text: dia.cenas[1].foto ?? '');
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
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, controlador.text.trim()), child: const Text('Guardar')),
                          ],
                        ),
                      );
                      if (nuevaFoto != null) {
                        setState(() {
                          menu[realIdx] = menu[realIdx].copyWith(
                            cenas: List.from(menu[realIdx].cenas)
                              ..[1] = menu[realIdx].cenas[1].copyWith(foto: nuevaFoto),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          )),
        ]);
      }).toList(),
    ),
  );
}
}