import 'package:conectask_v2/Utils/color_utils.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/tarea_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/task_add_view.dart';
import 'package:conectask_v2/widgets/navegacion.dart';
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
    final esHecha = tarea.estado == 'hecha' || tarea.estado == 'validada';
    final esValidada = tarea.validadaPor != null;
    final esAdulto = !['alex', 'erik'].contains(tarea.responsable);

    if (!esHecha) return Colors.grey;
    if (esValidada || esAdulto) return Colors.green;
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final usuarioController = Provider.of<UsuarioController>(context);
    final usuariosLocales = usuarioController.usuarios;
    final esAdulto = widget.user.rol == 'admin' || widget.user.rol == 'padre';
    final tareasHoy = controller.tareas.where((t) {
      final formato = DateFormat('yyyy-MM-dd');
      final mismaFecha =
          formato.format(t.fecha) ==
          formato.format(controller.fechaSeleccionada);
      final esDelUsuario = esAdulto || t.responsable == widget.user.id;
      return mismaFecha && esDelUsuario;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas Familiares"),
        actions: [
          if (widget.user.rol == "admin")
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Añadir nueva tarea',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskAddView()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Seleccionar día',
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
            tooltip: 'Ver en calendario',
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: usuariosLocales.length * 200.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: usuariosLocales.map((usuario) {
                    final color = obtenerColorUsuario(usuario);
                    final tareasUsuario = tareasHoy
                        .where((t) => t.responsable == usuario.id)
                        .toList();

                    return Container(
                      width: 180,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
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
                          tareasUsuario.isEmpty
                              ? const Text(
                                  'Sin tareas hoy',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              : ListView.builder(
                                  itemCount: tareasUsuario.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final tarea = tareasUsuario[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      elevation: 2,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 16,
                                            ),
                                        title: Text(
                                          tarea.titulo,
                                          style: TextStyle(
                                            decoration:
                                                (tarea.estado == 'hecha' ||
                                                    tarea.estado == 'validada')
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                        subtitle: Text(
                                          tarea.descripcion,
                                          style: TextStyle(
                                            decoration: tarea.estado == 'hecha'
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontStyle: tarea.estado == 'hecha'
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
                                                  tarea.prioridad == 'Alta'
                                                      ? Icons.flash_on
                                                      : tarea.prioridad ==
                                                            'Media'
                                                      ? Icons.access_time
                                                      : Icons.hourglass_bottom,
                                                  color:
                                                      tarea.prioridad == 'Alta'
                                                      ? Colors.red
                                                      : tarea.prioridad ==
                                                            'Media'
                                                      ? Colors.amber
                                                      : Colors.green,
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
                                                    (tarea.estado == 'hecha' ||
                                                            tarea.estado ==
                                                                'validada')
                                                        ? Icons.check_circle
                                                        : Icons
                                                              .radio_button_unchecked,
                                                    color: getColor(tarea),
                                                  ),
                                                  onPressed: () async {
                                                    final nuevoEstado =
                                                        tarea.estado == 'hecha'
                                                        ? 'pendiente'
                                                        : 'hecha';
                                                    await controller
                                                        .cambiarEstado(
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
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
