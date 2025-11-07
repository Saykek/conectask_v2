import 'package:flutter/material.dart';
import '../models/recompensa_model.dart';
import '../services/recompensa_service.dart';

class RecompensaAddView extends StatefulWidget {
  final RecompensaModel? recompensa;

  const RecompensaAddView({super.key, this.recompensa});

  @override
  State<RecompensaAddView> createState() => _AddRecompensaViewState();
}

class _AddRecompensaViewState extends State<RecompensaAddView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _costeController = TextEditingController();

  bool _visible = true;
  final RecompensaService _recompensaService = RecompensaService();

  @override
  void initState() {
    super.initState();
    if (widget.recompensa != null) {
      final r = widget.recompensa!;
      _nombreController.text = r.nombre;
      _descripcionController.text = r.descripcion ?? '';
      _costeController.text = r.coste.toString();
      _visible = r.visible;
    }
  }

  void _guardarRecompensa() async {
    if (_formKey.currentState!.validate()) {
      final nueva = RecompensaModel(
        id: widget.recompensa?.id ?? '',
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        coste: int.parse(_costeController.text.trim()),
        visible: _visible,
      );

      try {
        if (widget.recompensa == null) {
          await _recompensaService.guardarRecompensa(nueva);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recompensa añadida correctamente')),
          );
        } else {
          await _recompensaService.actualizarRecompensa(nueva);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recompensa actualizada correctamente')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recompensa == null ? 'Añadir recompensa' : 'Editar recompensa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
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
                controller: _costeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Coste en puntos'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Visible para los niños'),
                value: _visible,
                onChanged: (valor) {
                  setState(() {
                    _visible = valor;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarRecompensa,
                child: Text(widget.recompensa == null ? 'Guardar recompensa' : 'Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}