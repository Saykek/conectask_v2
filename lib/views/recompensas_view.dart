import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/recompensa_model.dart';
import '../controllers/recompensa_controller.dart';
import '../widgets/resumen_recompensas.dart';
import '../widgets/lista_recomepensas.dart';
import '../views/recompensa_add_view.dart';

class RecompensasView extends StatefulWidget {
  final UserModel user;

  const RecompensasView({super.key, required this.user});

  @override
  State<RecompensasView> createState() => _RecompensasViewState();
}

class _RecompensasViewState extends State<RecompensasView> {
  final RecompensaController _controller = RecompensaController();

  final List<UserModel> listaNinos = [
    UserModel(id: '1', nombre: 'Juan', rol: 'nino', nivel: 2, puntos: 80),
    UserModel(id: '2', nombre: 'Lucia', rol: 'nino', nivel: 3, puntos: 120),
    UserModel(id: '3', nombre: 'Mario', rol: 'nino', nivel: 1, puntos: 40),
  ];

  String seleccion = 'Todos';
  Map<String, List<RecompensaModel>> recompensasPorNino = {};
  List<RecompensaModel> listaGeneral = [];
  bool cargando = true;
  bool mostrarListaGeneral = false;

  @override
  void initState() {
    super.initState();
    _cargarRecompensas();

    if (widget.user.rol != 'admin') {
      _cargarListaGeneral();
    }
  }

  Future<void> _cargarRecompensas() async {
    final Map<String, List<RecompensaModel>> mapa = {};
    for (final nino in listaNinos) {
      final lista = await _controller.getRecompensasPara(nino);
      mapa[nino.id] = lista;
    }
    final propias = await _controller.getRecompensasPara(widget.user);
    mapa[widget.user.id] = propias;

    setState(() {
      recompensasPorNino = mapa;
      cargando = false;
    });
  }

  Future<void> _cargarListaGeneral() async {
    final lista = await _controller.getTodasLasRecompensas();
    setState(() {
      listaGeneral = lista;
      mostrarListaGeneral = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompensas'),
        actions: [
          if (widget.user.rol == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Añadir nueva recompensa',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecompensaAddView()),
                );
                await _cargarRecompensas();
              },
            ),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : widget.user.rol == 'admin'
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '👥 Selecciona un niño:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _botonSelector('Todos'),
                      ...listaNinos
                          .map((nino) => _botonSelector(nino.nombre))
                          .toList(),
                      const SizedBox(width: 8),
                      _botonRecompensas(),
                    ],
                  ),
                ),
                if (mostrarListaGeneral)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListaRecompensas(
                      recompensas: listaGeneral,
                      modoAdmin: true,
                      onTap: (r) {
                        // Acción al tocar recompensa (editar, ver detalle, etc.)
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: seleccion == 'Todos'
                        ? Column(
                            children: listaNinos
                                .map(
                                  (nino) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: ResumenRecompensas(
                                      user: nino,
                                      recompensas:
                                          recompensasPorNino[nino.id] ?? [],
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : ResumenRecompensas(
                            user: listaNinos.firstWhere(
                              (nino) => nino.nombre == seleccion,
                              orElse: () => listaNinos.first,
                            ),
                            recompensas:
                                recompensasPorNino[listaNinos
                                    .firstWhere(
                                      (nino) => nino.nombre == seleccion,
                                    )
                                    .id] ??
                                [],
                          ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResumenRecompensas(
                    user: widget.user,
                    recompensas: recompensasPorNino[widget.user.id] ?? [],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '🎁 Recompensas disponibles:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListaRecompensas(
                    recompensas: listaGeneral,
                    modoAdmin: false,
                    onTap: (r) {
                      // Aquí puedes mostrar detalle o permitir canje si tiene puntos suficientes
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _botonSelector(String nombre) {
    final bool activo = seleccion == nombre;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: activo ? Colors.blueAccent : Colors.grey[300],
          foregroundColor: activo ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            seleccion = nombre;
            mostrarListaGeneral = false;
          });
        },
        child: Text(nombre),
      ),
    );
  }

  Widget _botonRecompensas() {
    final bool activo = mostrarListaGeneral;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: activo
            ? Colors.greenAccent
            : const Color.fromARGB(255, 175, 248, 208),
        foregroundColor: Colors.black,
      ),
      onPressed: () async {
        if (!mostrarListaGeneral) {
          await _cargarListaGeneral();
        } else {
          setState(() {
            mostrarListaGeneral = false;
          });
        }
      },
      icon: const Icon(Icons.card_giftcard),
      label: const Text('Recompensas'),
    );
  }
}
