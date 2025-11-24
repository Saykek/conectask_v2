import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/views/recompensa_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Map<String, List<RecompensaModel>> recompensasPorNino = {};
  List<RecompensaModel> listaGeneral = [];
  bool cargando = true;
  bool mostrarListaGeneral = false;
  String seleccion = 'Todos';

  @override
  void initState() {
    super.initState();
    _cargarRecompensas().then((_) {
      setState(() {
        listaGeneral = recompensasPorNino[widget.user.id] ?? [];
        mostrarListaGeneral = true;
      });
    });
  } // 👈 a

  Future<void> _cargarRecompensas() async {
    final usuarioController = Provider.of<UsuarioController>(
      context,
      listen: false,
    );
    final ninos = usuarioController.usuarios
        .where((u) => u.rol == 'niño')
        .toList();

    final Map<String, List<RecompensaModel>> mapa = {};
    for (final nino in ninos) {
      final lista = await _controller.getRecompensasPara(nino);
      mapa[nino.id] = lista;
    }

    // Para el propio usuario
    if (widget.user.rol == 'admin') {
      mapa[widget.user.id] = await _controller.getTodasLasRecompensas();
    } else {
      mapa[widget.user.id] = await _controller.getRecompensasPara(widget.user);
    }

    setState(() {
      recompensasPorNino = mapa;
      cargando = false;
    });

    print(
      'DEBUG: recompensasPorNino[${widget.user.id}] -> ${recompensasPorNino[widget.user.id]?.map((r) => "${r.nombre}:${r.usada}")}',
    );
  }

  Future<void> _cargarListaGeneral() async {
    if (widget.user.rol == 'admin') {
      listaGeneral = await _controller.getTodasLasRecompensas();
    } else {
      listaGeneral = recompensasPorNino[widget.user.id] ?? [];
    }
    setState(() {
      mostrarListaGeneral = true;

      print(
        'DEBUG: listaGeneral -> ${listaGeneral.map((r) => "${r.nombre}:${r.usada}")}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    final List<UserModel> listaNinos = usuarioController.usuarios
        .where((u) => u.rol == 'niño')
        .toList();

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
                      modoAdmin: false,
                      onTap: (r) async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecompensaDetailView(
                              recompensa: r,
                              user: widget.user,
                            ),
                          ),
                        );
                        if (result == true) {
                          await _cargarRecompensas();
                          if (mounted) {
                            setState(() {
                              listaGeneral =
                                  recompensasPorNino[widget.user.id] ?? [];
                            });
                          }
                        }
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
          // Usamos los colores del tema en vez de fijos
          backgroundColor: activo
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          foregroundColor: activo
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
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
        shape: const StadiumBorder(),
        backgroundColor: activo
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.surface,
        foregroundColor: activo
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.onSurface,
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
