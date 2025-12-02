import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EstrellasNivel extends StatefulWidget {
  final int puntos;

  const EstrellasNivel({super.key, required this.puntos});

  @override
  State<EstrellasNivel> createState() => _EstrellasNivelState();
}

class _EstrellasNivelState extends State<EstrellasNivel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant EstrellasNivel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nivelActual = widget.puntos ~/ 100;
    final nivelPrevio = oldWidget.puntos ~/ 100;

    // Solo dispara la animación si se sube de nivel
    if (nivelActual > nivelPrevio) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nivel = widget.puntos ~/ 100;

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Lottie.asset(
            'assets/animaciones/5estrellas.json',
            controller: _controller,
            repeat: false,
            animate: true,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
          ),
        ),
        Text(
          'Nivel $nivel',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}