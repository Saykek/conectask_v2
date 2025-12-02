import 'package:conectask_v2/common/utils/color_utils.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/task_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final DateTime fechaInicial;
  final UserModel user;

  const CalendarView({
    super.key,
    required this.fechaInicial,
    required this.user,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    fechaSeleccionada = widget.fechaInicial;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TareaController>(context);
    final formato = DateFormat('yyyy-MM-dd');
    final tareasDelDia = controller.tareas
        .where(
          (t) => formato.format(t.fecha) == formato.format(fechaSeleccionada),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Calendario Familiar")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: fechaSeleccionada,
                selectedDayPredicate: (day) =>
                    isSameDay(day, fechaSeleccionada),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    fechaSeleccionada = selectedDay;
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  DateFormat('EEEE, d MMMM', 'es_ES').format(fechaSeleccionada),
                ),
                onPressed: () async {
                  final nuevaFecha = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (nuevaFecha != null) {
                    setState(() {
                      fechaSeleccionada = nuevaFecha;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                "Tareas para ${DateFormat('EEEE, d MMMM', 'es_ES').format(fechaSeleccionada)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              tareasDelDia.isEmpty
                  ? const Center(child: Text("No hay tareas para este día"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tareasDelDia.length,
                      itemBuilder: (context, index) {
                        final tarea = tareasDelDia[index];
                        final usuarioController =
                            Provider.of<UsuarioController>(
                              context,
                              listen: false,
                            );
                        final usuario = usuarioController.getUsuarioPorId(
                          tarea.responsable,
                        );
                        final color = usuario != null
                            ? obtenerColorUsuario(usuario)
                            : Colors.grey;


                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,
                              child: Text(
                                (usuario?.nombre ?? '?')[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(tarea.titulo),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tarea.descripcion,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Responsable: ${usuario?.nombre ?? 'Desconocido'}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              (tarea.estado == 'hecha' ||
                                      tarea.estado == 'validada')
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: obtenerColorTarea(tarea),
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
        ),
      ),
    );
  }
}
