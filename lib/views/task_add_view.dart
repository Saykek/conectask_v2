import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';
import '../services/tarea_sevice.dart';

class AddTaskView extends StatefulWidget {
  final Tarea? tarea; // Si llega una tarea, estamos editando

  const AddTaskView({super.key, this.tarea});

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

    // Si viene tarea, rellenamos campos
    if (widget.tarea != null) {
      final t = widget.tarea!;
      _tituloController.text = t.titulo;
      _descripcionController.text = t.descripcion;
      _fechaSeleccionada = t.fecha;
      _fechaController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(_fechaSeleccionada);
      _responsableSeleccionado = t.responsable;
      _prioridadSeleccionada = t.prioridad;
    } else {
      _fechaController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(_fechaSeleccionada);
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      //locale: const Locale('es', 'ES'),
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

      final tareaNueva = Tarea(
        id: widget.tarea?.id ?? '', // Reutiliza ID si estamos editando
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        fecha: _fechaSeleccionada,
        responsable: _responsableSeleccionado!,
        prioridad: _prioridadSeleccionada!,
        estado: widget.tarea?.estado ?? 'pendiente',
      );

      try {
        if (widget.tarea == null) {
          await _tareaService.guardarTarea(tareaNueva);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea añadida correctamente')),
          );
        } else {
          await _tareaService.actualizarTarea(tareaNueva);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea actualizada correctamente')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarea == null ? 'Añadir tarea' : 'Editar tarea'),
      ),
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
                child: Text(
                  widget.tarea == null ? 'Guardar tarea' : 'Guardar cambios',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
