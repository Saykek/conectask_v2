import 'package:conectask_v2/controllers/configuracion_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimacionToggle extends StatefulWidget {
  final ConfiguracionController configController;
  final UserModel user;

  const AnimacionToggle({
    super.key,
    required this.configController,
    required this.user,
  });

  @override
  State<AnimacionToggle> createState() => _AnimacionToggleState();
}

class _AnimacionToggleState extends State<AnimacionToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool oscuro = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);

    // Inicializamos según la configuración actual
    oscuro = widget.configController.configuracion.tema == 'oscuro';
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleTema() async {
    setState(() {
      oscuro = !oscuro;
      if (oscuro) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });

    // Actualizar y guardar en Firebase
    final nuevoTema = oscuro ? 'oscuro' : 'claro';
    widget.configController.actualizarCampo('tema', nuevoTema);
    await widget.configController.guardarConfiguracion(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleTema,
      child: Lottie.asset(
        'assets/animaciones/toogle.json',
        controller: _animController,
        onLoaded: (composition) {
          _animController.duration = composition.duration;
          _animController.value = oscuro
              ? 1.0
              : 0.0; // sincronizar estado inicial
        },
      ),
    );
  }
}
