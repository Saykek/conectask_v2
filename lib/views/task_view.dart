import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/views/task_add_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'task_detail_view.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  final List<Map<String, dynamic>> usuarios = const [
    {'nombre': 'Mamá', 'uid': 'mama', 'color': Colors.pinkAccent},
    {'nombre': 'Papá', 'uid': 'papa', 'color': Colors.blueAccent},
    {'nombre': 'Álex', 'uid': 'alex', 'color': Color(0xFF482D87)},
    {'nombre': 'Erik', 'uid': 'erik', 'color': Color(0xFF42B14D)},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final tareasHoy = controller.tareas
        .where((t) => DateFormat('yyyy-MM-dd').format(t.fecha) == hoy)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas Familiares"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Añadir nueva tarea',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: usuarios.map((usuario) {
            final color = usuario['color'] as Color;
            final tareasUsuario = tareasHoy
                .where((t) => t.responsable == usuario['uid'])
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
                    usuario['nombre'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (tareasUsuario.isEmpty)
                    const Text(
                      'Sin tareas hoy',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  else
                    ...tareasUsuario.map(
                      (tarea) => Card(
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
                              decoration: tarea.estado == 'hecha'
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
                                        : tarea.prioridad == 'Media'
                                        ? Icons.access_time
                                        : Icons.hourglass_bottom,
                                    color: tarea.prioridad == 'Alta'
                                        ? Colors.red
                                        : tarea.prioridad == 'Media'
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
                                      tarea.estado == 'hecha'
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: tarea.estado == 'hecha'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      final nuevoEstado =
                                          tarea.estado == 'hecha'
                                          ? 'pendiente'
                                          : 'hecha';
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
                                builder: (_) => TaskDetailView(tarea: tarea),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
