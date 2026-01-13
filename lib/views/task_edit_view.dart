import 'package:conectask_v2/common/constants/constant.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/tarea_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/tarea_controller.dart';

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

  final List<String> _prioridades = AppConstants.prioridades;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea.titulo);
    _descripcionController = TextEditingController(
      text: widget.tarea.descripcion,
    );
    _fechaSeleccionada = widget.tarea.fecha;
    _fechaController = TextEditingController(
      text: DateFormat(AppConstants.formatoFecha).format(_fechaSeleccionada),
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
      locale: AppConstants.localeEs,
    );
    if (seleccionada != null && seleccionada != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = seleccionada;
        _fechaController.text = DateFormat(
          AppConstants.formatoFecha,
        ).format(_fechaSeleccionada);
      });
    }
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      if (_responsableSeleccionado == null || _prioridadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppMessagesConstants.msgCompletaCampos)),
        );
        return;
      }

      // Validación de fecha: no se puede poner anterior a hoy
      final hoy = DateTime.now();
      final fechaSinHora = DateTime(
        _fechaSeleccionada.year,
        _fechaSeleccionada.month,
        _fechaSeleccionada.day,
      );
      final hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);

      if (fechaSinHora.isBefore(hoySinHora)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppMessagesConstants.msgFechaAnterior)),
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
          const SnackBar(
            content: Text(AppMessagesConstants.msgTareaActualizada),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppMessagesConstants.msgErrorActualizar}: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    final usuariosDisponibles = usuarioController.usuarios;
    return Scaffold(
      appBar: AppBar(title: const Text(AppMessagesConstants.tituloEditarTarea)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelTitulo,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? AppMessagesConstants.msgCampoObligatorio
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelDescripcion,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppFieldsConstants.labelFecha,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _seleccionarFecha(context),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _responsableSeleccionado,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelAsignarA,
                ),
                items: usuariosDisponibles.map((usuario) {
                  return DropdownMenuItem<String>(
                    value: usuario.id,
                    child: Text(usuario.nombre),
                  );
                }).toList(),
                onChanged: (valor) =>
                    setState(() => _responsableSeleccionado = valor),
                validator: (value) => value == null
                    ? AppMessagesConstants.msgSeleccionaResponsable
                    : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelPrioridad,
                ),
                items: _prioridades
                    .map(
                      (p) => DropdownMenuItem<String>(value: p, child: Text(p)),
                    )
                    .toList(),
                onChanged: (valor) =>
                    setState(() => _prioridadSeleccionada = valor),
                validator: (value) => value == null
                    ? AppMessagesConstants.msgSeleccionaPrioridad
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text(AppMessagesConstants.btnGuardarCambios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
