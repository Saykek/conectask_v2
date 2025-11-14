import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/user_service.dart';
import 'package:flutter/material.dart';

class CrearNinoView extends StatefulWidget {
  final UserModel? nino; // null si es nuevo

  const CrearNinoView({super.key, this.nino});

  @override
  State<CrearNinoView> createState() => _CrearNinoViewState();
}

class _CrearNinoViewState extends State<CrearNinoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _pinController;
  late TextEditingController _puntosController;
  late int _nivel;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nino?.nombre ?? '');
    _pinController = TextEditingController(text: widget.nino?.pin ?? '');
    _puntosController = TextEditingController(
      text: widget.nino?.puntos?.toString() ?? '0',
    );
    _nivel = widget.nino?.nivel ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.nino != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar perfil de niño' : 'Crear perfil de niño'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Escribe un nombre' : null,
              ),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'PIN'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.length != 4 ? 'PIN de 4 cifras' : null,
              ),
              DropdownButtonFormField<int>(
                value: _nivel,
                decoration: const InputDecoration(labelText: 'Nivel'),
                items: List.generate(5, (i) => i + 1)
                    .map((n) => DropdownMenuItem(value: n, child: Text('Nivel $n')))
                    .toList(),
                onChanged: (value) => setState(() => _nivel = value ?? 1),
              ),
              TextFormField(
                controller: _puntosController,
                decoration: const InputDecoration(labelText: 'Puntos'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Introduce los puntos';
                  final puntos = int.tryParse(value);
                  if (puntos == null || puntos < 0) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoNino = UserModel(
                      id: widget.nino?.id ??
                          'uid_${_nombreController.text}_${DateTime.now().millisecondsSinceEpoch}',
                      nombre: _nombreController.text,
                      rol: 'niño',
                      pin: _pinController.text,
                      nivel: _nivel,
                      puntos: int.tryParse(_puntosController.text) ?? 0,
                    );

                    await UserService().guardarUsuario(nuevoNino);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(esEdicion
                            ? 'Niño actualizado correctamente'
                            : 'Niño creado correctamente'),
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}