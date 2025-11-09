import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/tarea_model.dart';

class EditTaskView extends StatefulWidget {
  final Tarea tarea;

  const EditTaskView({super.key, required this.tarea});

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fechaController;

  String? _responsableSeleccionado;
  String? _prioridadSeleccionada;
  late DateTime _fechaSeleccionada;

  final List<UserModel> _usuarios = [
    UserModel(id: 'mama', nombre: 'Mamá', rol: 'adulto'),
    UserModel(id: 'papa', nombre: 'Papá', rol: 'adulto'),
    UserModel(id: 'alex', nombre: 'Álex', rol: 'niño'),
    UserModel(id: 'erik', nombre: 'Erik', rol: 'niño'),
  ];

  final List<String> _prioridades = ['Alta', 'Media', 'Baja'];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea.titulo);
    _descripcionController = TextEditingController(
      text: widget.tarea.descripcion,
    );
    _fechaSeleccionada = widget.tarea.fecha;
    _fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_fechaSeleccionada),
    );
    _responsableSeleccionado = widget.tarea.responsable;
    _prioridadSeleccionada = widget.tarea.prioridad;
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

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      if (_responsableSeleccionado == null || _prioridadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa todos los campos')),
        );
        return;
      }

      final tareaActualizada = Tarea(
        id: widget.tarea.id,
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        fecha: _fechaSeleccionada,
        responsable: _responsableSeleccionado!,
        prioridad: _prioridadSeleccionada!,
        estado: widget.tarea.estado,
      );

      try {
        final controller = Provider.of<TareaController>(context, listen: false);
        await controller.actualizarTarea(tareaActualizada);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea actualizada correctamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar tarea: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar tarea')),
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
                    value: usuario.id,
                    child: Text(usuario.nombre),
                  );
                }).toList(),
                onChanged: (valor) =>
                    setState(() => _responsableSeleccionado = valor),
                validator: (value) =>
                    value == null ? 'Selecciona un responsable' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: _prioridades
                    .map(
                      (p) => DropdownMenuItem<String>(value: p, child: Text(p)),
                    )
                    .toList(),
                onChanged: (valor) =>
                    setState(() => _prioridadSeleccionada = valor),
                validator: (value) =>
                    value == null ? 'Selecciona una prioridad' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
