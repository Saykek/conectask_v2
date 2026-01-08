import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/views/recompensa_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/constants/constant.dart';
import '../models/user_model.dart';
import '../models/recompensa_model.dart';
import '../controllers/recompensa_controller.dart';
import '../common/widgets/resumen_recompensas.dart';
import '../common/widgets/lista_recompensas.dart';
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
  bool cargando = true;
  bool mostrarListaGeneral = false;
  String seleccion = AppFieldsConstants.todos;

  @override
  void initState() {
    super.initState();
    _cargarRecompensas();
  }

  Future<void> _cargarRecompensas() async {
    final usuarioController = Provider.of<UsuarioController>(
      context,
      listen: false,
    );
    final ninos = usuarioController.usuarios
        .where((u) => u.rol == AppConstants.rolNino)
        .toList();

    final Map<String, List<RecompensaModel>> mapa = {};
    for (final nino in ninos) {
      mapa[nino.id] = await _controller.getRecompensasPara(nino);
    }

    if (widget.user.rol == AppConstants.rolAdmin) {
      mapa[widget.user.id] = await _controller.getTodasLasRecompensas();
    } else {
      mapa[widget.user.id] = await _controller.getRecompensasPara(widget.user);
    }

    setState(() {
      recompensasPorNino = mapa;
      cargando = false;
    });
  }

  Future<void> _cargarListaGeneral() async {
    if (widget.user.rol == AppConstants.rolAdmin) {
      recompensasPorNino[widget.user.id] = await _controller
          .getTodasLasRecompensas();
    }
    setState(() {
      mostrarListaGeneral = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    final listaNinos = usuarioController.usuarios
        .where((u) => u.rol == AppConstants.rolNino)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppFieldsConstants.recompensas),
        actions: [
          if (widget.user.rol == AppConstants.rolAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: AppFieldsConstants.anadirNuevaRecompensa,
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.user.rol == AppConstants.rolAdmin)
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _botonSelector(AppFieldsConstants.todos),
                        ...listaNinos.map((n) => _botonSelector(n.nombre)),
                        const SizedBox(width: 8),
                        _botonRecompensas(),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: widget.user.rol == AppConstants.rolAdmin
                      ? (mostrarListaGeneral
                            ? ListView(
                                padding: const EdgeInsets.all(16),
                                children: recompensasPorNino[widget.user.id]!
                                    .map(
                                      (r) => ListaRecompensas(
                                        recompensas: [r],
                                        modoAdmin: true,
                                        onTap: (recompensa) async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RecompensaDetailView(
                                                    recompensa: recompensa,
                                                    user: widget.user,
                                                  ),
                                            ),
                                          );
                                          await _cargarRecompensas();
                                        },
                                      ),
                                    )
                                    .toList(),
                              )
                            : ListView(
                                children: listaNinos.map((nino) {
                                  if (seleccion == AppFieldsConstants.todos ||
                                      seleccion == nino.nombre) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: ResumenRecompensas(user: nino),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }).toList(),
                              ))
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            // TARJETA DEL NIÑO (ResumenRecompensas)
                            ResumenRecompensas(user: widget.user),
                            /*  const SizedBox(height: 16),
                          const Text(
                            AppFieldsConstants.recompensasDisponibles,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // LISTA DE RECOMPENSAS QUE PUEDE CANJEAR
                          ...?recompensasPorNino[widget.user.id]?.map(
                            (r) => ListaRecompensas(
                              recompensas: [r],
                              modoAdmin: false,
                              onTap: (recompensa) async {
                                try {
                                  await _controller.canjear(
                                      widget.user, recompensa);
                                      // REFRESCAR lista después de canjear
                                  final recompensasActualizadas =
        await _controller.getRecompensasPara(widget.user);
    setState(() {
      recompensasPorNino[widget.user.id] = recompensasActualizadas;
    });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            ),
                          ),*/
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  Widget _botonSelector(String nombre) {
    final bool activo = seleccion == nombre;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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
        _cargarListaGeneral();
      },
      icon: const Icon(Icons.card_giftcard),
      label: const Text(AppFieldsConstants.recompensas),
    );
  }
}
