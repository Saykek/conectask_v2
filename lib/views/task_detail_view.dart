import 'package:conectask_v2/Utils/usuarios_local.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/tarea_sevice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';
import 'task_edit_view.dart';

class TaskDetailView extends StatefulWidget {
  final Tarea tarea;
  final UserModel user;
  

  const TaskDetailView({Key? key, required this.tarea, required this.user}) : super(key: key);

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final TareaService _tareaService = TareaService();
  late Tarea tarea;
  
bool puedeValidarse(Tarea tarea) {
    const ninos = ['alex', 'erik'];
    return ninos.contains(tarea.responsable);
  }

  @override
  void initState() {
    super.initState();
    tarea = widget.tarea;
  }

  Future<void> _actualizarEstado() async {
    final esNino = puedeValidarse(tarea);
    final esAdmin = widget.user.rol == 'admin';

    try {
      if (tarea.estado == 'pendiente') {
        if (esNino) {
          await _tareaService.actualizarEstadoTarea(tarea, 'hecha');
          setState(() {
            tarea = Tarea(
              id: tarea.id,
              titulo: tarea.titulo,
              descripcion: tarea.descripcion,
              responsable: tarea.responsable,
              fecha: tarea.fecha,
              prioridad: tarea.prioridad,
              estado: 'hecha',
              recompensa: tarea.recompensa,
              validadaPor: null,
              puntos: tarea.puntos,
            );
          });
        } else {
          await _tareaService.validarTarea(tarea, widget.user.id);
          setState(() {
            tarea = Tarea(
              id: tarea.id,
              titulo: tarea.titulo,
              descripcion: tarea.descripcion,
              responsable: tarea.responsable,
              fecha: tarea.fecha,
              prioridad: tarea.prioridad,
              estado: 'validada',
              recompensa: tarea.recompensa,
              validadaPor: widget.user.id,
              puntos: tarea.puntos,
            );
          });
        }
      } else if (tarea.estado == 'hecha' &&
          esAdmin &&
          esNino &&
          tarea.validadaPor == null) {
        await _tareaService.validarTarea(tarea, widget.user.id);
        setState(() {
          tarea = Tarea(
            id: tarea.id,
            titulo: tarea.titulo,
            descripcion: tarea.descripcion,
            responsable: tarea.responsable,
            fecha: tarea.fecha,
            prioridad: tarea.prioridad,
            estado: 'validada',
            recompensa: tarea.recompensa,
            validadaPor: widget.user.id,
            puntos: tarea.puntos,
          );
        });
      } else {
        await _tareaService.actualizarEstadoTarea(tarea, 'pendiente');
        setState(() {
          tarea = Tarea(
            id: tarea.id,
            titulo: tarea.titulo,
            descripcion: tarea.descripcion,
            responsable: tarea.responsable,
            fecha: tarea.fecha,
            prioridad: tarea.prioridad,
            estado: 'pendiente',
            recompensa: tarea.recompensa,
            validadaPor: null,
            puntos: tarea.puntos,
          );
        });
      }

    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      tarea.estado == 'validada'
          ? 'Tarea validada y puntos asignados'
          : tarea.estado == 'hecha'
              ? 'Tarea marcada como hecha'
              : 'Estado actualizado',
    ),
  ),
);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar tarea: $e')),
    );
  }
}
  void _editarTarea() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskView(tarea: tarea)),
    );

    if (resultado is Tarea) {
      setState(() {
        tarea = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat('dd/MM/yyyy').format(tarea.fecha);

    return Scaffold(
      appBar: AppBar(
        title: Text(tarea.titulo),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editarTarea),
          if (tarea.estado != 'hecha')
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar tarea'),
                    content: const Text(
                      '¿Seguro que quieres eliminar esta tarea? Esta acción no se puede deshacer.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmar == true) {
                  if (confirmar == true) {
                    await _tareaService.eliminarTareaDesdeObjeto(tarea);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tarea eliminada correctamente'),
                        ),
                      );
                      Navigator.pop(context); // Volver al listado
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tarea.titulo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        tarea.estado == 'hecha'
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: tarea.estado == 'hecha'
                            ? Colors.green
                            : Colors.grey,
                        size: 30,
                      ),
                      onPressed: _actualizarEstado,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '📅 Fecha: $fechaFormateada',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '👤 Responsable: ${tarea.responsable}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '🔥 Prioridad: ${tarea.prioridad}',
                  style: const TextStyle(fontSize: 16),
                ),
                  const SizedBox(height: 8),
                  Text(
                    '⭐ Puntos: ${tarea.puntos ?? 0}',
                    style: const TextStyle(fontSize: 16),
                  ),
                
                const SizedBox(height: 8),
                Text(
                  '📝 Descripción:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tarea.descripcion,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 16),
                if (widget.user.rol == 'admin' &&
    tarea.estado == 'hecha' &&
    tarea.validadaPor == null &&
    puedeValidarse(tarea))
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: ElevatedButton.icon(
      icon: const Icon(Icons.verified, color: Colors.white),
      label: const Text('Validar tarea'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: _actualizarEstado,
    ),
  ),
                if (tarea.validadaPor != null)
                  Text(
                   '✅ Validada por: ${getNombreUsuario(tarea.validadaPor!)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
