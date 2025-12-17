import 'package:conectask_v2/common/constants/constant.dart';
import 'package:conectask_v2/common/utils/color_utils.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/tarea_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/task_add_view.dart';
import 'package:conectask_v2/common/widgets/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'task_detail_view.dart';

class TasksView extends StatefulWidget {
  final UserModel user;

  const TasksView({super.key, required this.user});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  Color getColor(Tarea tarea) {
    final esHecha = tarea.estado == AppConstants.estadoHecha ||
        tarea.estado == AppConstants.estadoValidada;
    final esValidada = tarea.validadaPor != null;
    final esAdulto = !AppConstants.idsNinos.contains(tarea.responsable);

    if (!esHecha) return AppThemeConstants.colorPendiente;
    if (esValidada || esAdulto) return AppThemeConstants.colorValidada;
    return AppThemeConstants.colorHecha;
  }

  final ScrollController usuariosScrollController = ScrollController();

  @override
  void dispose() {
    usuariosScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final usuarioController = Provider.of<UsuarioController>(context);
    final usuariosLocales = usuarioController.usuarios;

    final esAdulto = widget.user.rol == AppConstants.rolAdmin ||
        widget.user.rol == AppConstants.rolPadre;
    final usuariosFiltrados = esAdulto
      ? usuariosLocales
      : usuariosLocales.where((u) => u.id == widget.user.id).toList();



    final tareasHoy = controller.tareas.where((t) {
      final formato = DateFormat(AppConstants.formatoFecha);
      final mismaFecha =
          formato.format(t.fecha) == formato.format(controller.fechaSeleccionada);
      final esDelUsuario = esAdulto || t.responsable == widget.user.id;

      return mismaFecha && esDelUsuario;  
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMessagesConstants.tituloTareasFamiliares),
        actions: [
          if (widget.user.rol == AppConstants.rolAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: AppMessagesConstants.tooltipAddTask,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskAddView()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: AppMessagesConstants.tooltipSeleccionarDia,
            onPressed: () async {
              final fechaSeleccionada = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
              );
              if (fechaSeleccionada != null) {
                controller.setFechaSeleccionada(fechaSeleccionada);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: AppMessagesConstants.tooltipVerCalendario,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarView(
                    fechaInicial: controller.fechaSeleccionada,
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
        ],
      ),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: NavegacionFecha(
              fechaActual: controller.fechaSeleccionada,
              onFechaCambiada: controller.setFechaSeleccionada,
            ),
          ),
          Expanded(
  child: Scrollbar(
    controller: usuariosScrollController,
    thumbVisibility: true,
    child: ListView.builder(
      controller: usuariosScrollController,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: usuariosFiltrados.length,
      itemBuilder: (context, i) {
        final usuario = usuariosFiltrados[i];
        final color = obtenerColorUsuario(usuario);
        final tareasUsuario = tareasHoy
            .where((t) => t.responsable == usuario.id)
            .toList();

        return SizedBox(
          width: 180,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nombre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: tareasUsuario.isEmpty
                      ? const Text(
                          AppMessagesConstants.msgSinTareasHoy,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : ListView.builder(
                        
                          key: PageStorageKey('tareas_${usuario.id}'),
                          primary: false,
                          physics: const ClampingScrollPhysics(),
                          itemCount: tareasUsuario.length,
                          itemBuilder: (context, index) {
                            final tarea = tareasUsuario[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                title: Text(
                                  tarea.titulo,
                                  style: TextStyle(
                                    decoration: (tarea.estado ==
                                                AppConstants.estadoHecha ||
                                            tarea.estado ==
                                                AppConstants.estadoValidada)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text(
                                  tarea.descripcion,
                                  style: TextStyle(
                                    decoration: tarea.estado ==
                                            AppConstants.estadoHecha
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontStyle: tarea.estado ==
                                            AppConstants.estadoHecha
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 48,
                                  height: 56,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        top: -18,
                                        right: 2,
                                        child: Icon(
                                          tarea.prioridad ==
                                                  AppConstants.prioridadAlta
                                              ? Icons.flash_on
                                              : tarea.prioridad ==
                                                      AppConstants.prioridadMedia
                                                  ? Icons.access_time
                                                  : Icons.hourglass_bottom,
                                          color: tarea.prioridad ==
                                                  AppConstants.prioridadAlta
                                              ? AppThemeConstants
                                                  .colorPrioridadAlta
                                              : tarea.prioridad ==
                                                      AppConstants.prioridadMedia
                                                  ? AppThemeConstants
                                                      .colorPrioridadMedia
                                                  : AppThemeConstants
                                                      .colorPrioridadBaja,
                                          size: 22,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -15,
                                        right: -2,
                                        child: IconButton(
                                          iconSize: 26,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 20,
                                          icon: Icon(
                                            (tarea.estado ==
                                                        AppConstants.estadoHecha ||
                                                    tarea.estado ==
                                                        AppConstants.estadoValidada)
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: getColor(tarea),
                                          ),
                                          onPressed: () async {
                                            final nuevoEstado =
                                                tarea.estado ==
                                                        AppConstants.estadoHecha
                                                    ? AppConstants
                                                        .estadoPendiente
                                                    : AppConstants.estadoHecha;
                                            await controller.cambiarEstado(
                                              tarea,
                                              nuevoEstado,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TaskDetailView(
                                        tarea: tarea,
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
),
        ],
      )
      );
  }
}