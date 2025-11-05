import 'package:conectask_v2/services/tarea_sevice.dart';
import 'package:conectask_v2/views/task_detail_view.dart';
import 'package:flutter/material.dart';
import '../models/tarea_model.dart';
import 'task_add_view.dart';
import 'package:intl/intl.dart';

class TasksView extends StatelessWidget {
  final List<Map<String, dynamic>> usuarios = [
    {'nombre': 'Mamá', 'uid': 'mama', 'color': Colors.pink[200]},
    {'nombre': 'Papá', 'uid': 'papa', 'color': Colors.blue[200]},
    {
      'nombre': 'Álex',
      'uid': 'alex',
      'color': const Color.fromARGB(255, 72, 45, 135),
    },
    {
      'nombre': 'Erik',
      'uid': 'erik',
      'color': const Color.fromARGB(255, 66, 177, 77),
    },
  ];

  final TareaService _tareaService = TareaService();

  TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
                MaterialPageRoute(builder: (context) => const AddTaskView()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Tarea>>(
        stream: _tareaService.escucharTareas(),
        builder: (context, snapshot) {
          final hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());
          final tareas = snapshot.hasData
              ? snapshot.data!
                    .where(
                      (t) => DateFormat('yyyy-MM-dd').format(t.fecha) == hoy,
                    )
                    .toList()
              : [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: usuarios.map((usuario) {
                final color = usuario['color'] ?? Colors.grey;
                final tareasUsuario = tareas
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
                        usuario['nombre'],
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

                            // ListTile para cada tarea.......................
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
                                tarea.descripcion.isNotEmpty
                                    ? tarea.descripcion
                                    : '',
                                style: TextStyle(
                                  decoration: tarea.estado == 'hecha'
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontStyle: tarea.estado == 'hecha'
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),

                              // ZONA DE ICONOSSSSSSSSSSSSSSSSS
                              trailing: SizedBox(
                                width: 48,
                                height: 56,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // 🔥 Icono de prioridad arriba a la derecha
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

                                    // ✅ Botón de estado abajo a la derecha
                                    Positioned(
                                      bottom: -15,
                                      right: -2,
                                      child: IgnorePointer(
                                        ignoring:
                                            false, // Asegura que reciba los toques
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
                                            await _tareaService
                                                .actualizarEstadoTarea(
                                                  tarea,
                                                  nuevoEstado,
                                                );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskDetailView(tarea: tarea),
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
          );
        },
      ),
    );
  }
}
