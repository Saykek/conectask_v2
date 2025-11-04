import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';
import '../services/tarea_sevice.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  final TareaService _tareaService = TareaService();

  String? _responsableSeleccionado;
  String? _prioridadSeleccionada;
  DateTime _fechaSeleccionada = DateTime.now();

  final List<Map<String, dynamic>> _usuarios = [
    {'nombre': 'Mamá', 'uid': 'mama'},
    {'nombre': 'Papá', 'uid': 'papa'},
    {'nombre': 'Álex', 'uid': 'alex'},
    {'nombre': 'Erik', 'uid': 'erik'},
  ];

  final List<String> _prioridades = ['Alta', 'Media', 'Baja'];

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormat('yyyy-MM-dd').format(_fechaSeleccionada);
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (seleccionada != null && seleccionada != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = seleccionada;
        _fechaController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(_fechaSeleccionada);
      });
    }
  }

  void _guardarTarea() async {
    if (_formKey.currentState!.validate()) {
      if (_responsableSeleccionado == null || _prioridadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa todos los campos')),
        );
        return;
      }

      final nuevaTarea = Tarea(
        id: '',
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        fecha: _fechaSeleccionada,
        responsable: _responsableSeleccionado!,
        prioridad: _prioridadSeleccionada!,
        estado: 'pendiente',
      );

      print('🟢 Enviando tarea al servicio...');
      try {
        await _tareaService.guardarTarea(nuevaTarea);
        print('✅ Tarea guardada correctamente');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea añadida correctamente')),
        );

        Navigator.pop(context);
      } catch (e) {
        print('❌ Error al guardar tarea: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir nueva tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _seleccionarFecha(context),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _responsableSeleccionado,
                decoration: const InputDecoration(labelText: 'Asignar a'),
                items: _usuarios.map((usuario) {
                  return DropdownMenuItem<String>(
                    value: usuario['uid'],
                    child: Text(usuario['nombre']),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _responsableSeleccionado = valor;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecciona un responsable' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: _prioridades.map((p) {
                  return DropdownMenuItem<String>(value: p, child: Text(p));
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _prioridadSeleccionada = valor;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecciona una prioridad' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarTarea,
                child: const Text('Guardar tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
