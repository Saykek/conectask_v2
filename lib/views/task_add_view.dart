import 'package:conectask_v2/common/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/tarea_controller.dart';
import '../controllers/usuario_controller.dart';
import '../models/tarea_model.dart';
import '../models/user_model.dart';

class TaskAddView extends StatefulWidget {
  final Tarea? tarea; // Si llega una tarea, estamos editando

  const TaskAddView({super.key, this.tarea});

  @override
  State<TaskAddView> createState() => _TaskAddViewState();
}

class _TaskAddViewState extends State<TaskAddView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _puntosController = TextEditingController();

  String? _responsableSeleccionado;
  String? _prioridadSeleccionada;
  DateTime _fechaSeleccionada = DateTime.now();

  final List<String> _prioridades = AppConstants.prioridades;
  Map<String, int> titulosConPuntos = {};

  @override
  void initState() {
    super.initState();

    if (widget.tarea != null) {
      final t = widget.tarea!;
      _tituloController.text = t.titulo;
      _descripcionController.text = t.descripcion;
      _fechaSeleccionada = t.fecha;
      _fechaController.text =
          DateFormat(AppConstants.formatoFecha).format(_fechaSeleccionada);
      _responsableSeleccionado = t.responsable;
      _prioridadSeleccionada = t.prioridad;
      if (t.puntos != null) {
        _puntosController.text = t.puntos!.toString();
      }
    } else {
      _fechaController.text =
          DateFormat(AppConstants.formatoFecha).format(_fechaSeleccionada);
    }

    cargarTitulos();
  }

  Future<void> cargarTitulos() async {
    final controller = Provider.of<TareaController>(context, listen: false);
    final datos = await controller.cargarTitulosConPuntos();
    setState(() {
      titulosConPuntos = datos;
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final hoy = DateTime.now();
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(hoy.year, hoy.month, hoy.day),
      lastDate: DateTime(2100),
      locale: AppConstants.localeEs,
    );
    if (seleccionada != null) {
      setState(() {
        _fechaSeleccionada = seleccionada;
        _fechaController.text =
            DateFormat(AppConstants.formatoFecha).format(_fechaSeleccionada);
      });
    }
  }

  void _guardarTarea() async {
    final hoy = DateTime.now();
    final hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);
    final fechaSinHora = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
    );

    if (fechaSinHora.isBefore(hoySinHora)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppMessagesConstants.msgFechaPasada)),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_responsableSeleccionado == null ||
          _prioridadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppMessagesConstants.msgCompletaCampos)),
        );
        return;
      }

      final tareaNueva = Tarea(
        id: widget.tarea?.id ?? '',
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        fecha: _fechaSeleccionada,
        responsable: _responsableSeleccionado!,
        prioridad: _prioridadSeleccionada!,
        estado: widget.tarea?.estado ?? AppConstants.estadoPendiente,
        puntos: _puntosController.text.isNotEmpty
            ? int.tryParse(_puntosController.text)
            : null,
      );

      try {
        final controller = Provider.of<TareaController>(context, listen: false);
        await controller.guardarTareaDesdeFormulario(
          tareaNueva,
          esNueva: widget.tarea == null,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.tarea == null
                  ? AppMessagesConstants.msgTareaGuardada
                  : AppMessagesConstants.msgTareaActualizada,
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${AppMessagesConstants.msgErrorActualizar}: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    final List<UserModel> usuariosDisponibles = usuarioController.usuarios;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tarea == null
              ? AppMessagesConstants.tituloAddTarea
              : AppMessagesConstants.tituloEditarTarea,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return titulosConPuntos.keys.where(
                    (titulo) => titulo
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()),
                  );
                },
                onSelected: (String seleccion) {
                  _tituloController.text = seleccion;
                  final puntos = titulosConPuntos[seleccion];
                  if (puntos != null) {
                    _puntosController.text = puntos.toString();
                  }
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: AppFieldsConstants.labelTitulo,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppMessagesConstants.msgCampoObligatorio
                        : null,
                    onChanged: (value) {
                      _tituloController.text = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelDescripcion,
                ),
              ),
              TextFormField(
                controller: _puntosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelPuntosRcomepensa,
                  suffixIcon: Icon(Icons.star),
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return AppMessagesConstants.msgDebeSerNumero;
                  }
                  return null;
                },
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
                validator: (value) =>
                    value == null
                        ? AppMessagesConstants.msgResponsableRequerido
                        : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(
                  labelText: AppFieldsConstants.labelPrioridad,
                ),
                items: _prioridades
                    .map((p) =>
                        DropdownMenuItem<String>(value: p, child: Text(p)))
                    .toList(),
                onChanged: (valor) =>
                    setState(() => _prioridadSeleccionada = valor),
                validator: (value) =>
                    value == null
                        ? AppMessagesConstants.msgPrioridadRequerida
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarTarea,
                child: Text(
                  widget.tarea == null
                      ? AppMessagesConstants.btnGuardarTarea
                      : AppMessagesConstants.btnGuardarCambios,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
