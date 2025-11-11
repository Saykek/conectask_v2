import 'package:conectask_v2/Utils/color_utils.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/task_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class CalendarView extends StatelessWidget {
  final DateTime fechaInicial;
  final UserModel user;

  const CalendarView({super.key, required this.fechaInicial, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final formato = DateFormat('yyyy-MM-dd');
    final tareasDelDia = controller.tareas
    .where((t) => formato.format(t.fecha) == formato.format(fechaInicial))
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario Familiar"),
      ),
      body: Column(
        children: [
          // Selector de fecha
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(DateFormat('EEEE, d MMMM', 'es_ES').format(fechaInicial)),
              onPressed: () async {
                final nuevaFecha = await showDatePicker(
                  context: context,
                  initialDate: fechaInicial,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                if (nuevaFecha != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalendarView(fechaInicial: nuevaFecha, user:user),
                    ),
                  );
                }
              },
            ),
          ),

          // Lista de tareas del día
          Expanded(
            child: tareasDelDia.isEmpty
                ? const Center(child: Text("No hay tareas para este día"))
                : ListView.builder(
                    itemCount: tareasDelDia.length,
                    itemBuilder: (context, index) {
                      final tarea = tareasDelDia[index];
                      final color = coloresUsuarios[tarea.responsable] ?? Colors.grey;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                          backgroundColor: color,
                          child: Text(
                          tarea.responsable[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(tarea.titulo),
                          subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tarea.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 4),
                          Text("Responsable: ${tarea.responsable}",
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                          ),
                        ],
                      ),
                          trailing: Icon(
                            tarea.estado == 'hecha'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: tarea.estado == 'hecha' ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailView(tarea: tarea, user:user,),
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
    );
  }
}