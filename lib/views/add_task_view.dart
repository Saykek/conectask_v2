import 'package:flutter/material.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  // Controladores para leer el texto de los TextField
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  // Estado de la fecha seleccionada
  DateTime? _fechaSeleccionada;

  // Estado de la prioridad
  String _prioridad = 'Normal'; // Valor inicial

  @override
  void dispose() {
    // Liberamos memoria al cerrar la vista
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Método para mostrar el selector de fecha
  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),

            // Campo de descripción
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Selector de fecha
            Row(
              children: [
                const Text('Fecha: '),
                Text(
                  _fechaSeleccionada != null
                      ? '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'
                      : 'No seleccionada',
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  child: const Text('Seleccionar fecha'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selector de prioridad
            Row(
              children: [
                const Text('Prioridad: '),
                DropdownButton<String>(
                  value: _prioridad,
                  items: const [
                    DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                    DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'Baja', child: Text('Baja')),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() {
                        _prioridad = valor;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Botón de guardar (de momento solo cierra la vista)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Aquí guardaremos la tarea en el futuro
                  Navigator.pop(context);
                },
                child: const Text('Guardar tarea'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
