import 'package:conectask_v2/Utils/color_utils.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/task_add_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'task_detail_view.dart';

class TasksView extends StatelessWidget {
  final UserModel user;
  TasksView({super.key, required this.user});
  

  final List<UserModel> usuarios = [
    UserModel(id: 'mama', nombre: 'Mamá', rol: 'adulto'),
    UserModel(id: 'papa', nombre: 'Papá', rol: 'adulto'),
    UserModel(id: 'alex', nombre: 'Álex', rol: 'niño'),
    UserModel(id: 'erik', nombre: 'Erik', rol: 'niño'),
  ];


  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final formato = DateFormat('yyyy-MM-dd');
    final fechaTexto = DateFormat('EEEE, d MMMM', 'es_ES')
    .format(controller.fechaSeleccionada);
    final tareasHoy = controller.tareas
    .where((t) => formato.format(t.fecha) == formato.format(controller.fechaSeleccionada))
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
                MaterialPageRoute(builder: (_) => const TaskAddView()),
              );
            },
          ),
          IconButton(
  icon: const Icon(Icons.calendar_today),
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
  icon: const Icon(Icons.view_agenda),
  tooltip: 'Ver en calendario',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarView(fechaInicial: controller.fechaSeleccionada, user: user,),
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
      padding: const EdgeInsets.all(16),
      child: Text(
        "Tareas para el día: $fechaTexto",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    Expanded(
 
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: usuarios.map((usuario) {
            final color = coloresUsuarios[usuario.id] ?? Colors.grey;
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
                                builder: (_) => TaskDetailView(tarea: tarea, user: user,),
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
      ),
    ],
  ),
); 
} 
}