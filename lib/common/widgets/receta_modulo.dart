import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecetaModulo extends StatelessWidget {
  final String assetPath; // ruta del JSON de la animación
  final double factor; // proporción del ancho del card (0.7 = 70%)

  const RecetaModulo({super.key, required this.assetPath, this.factor = 1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula el tamaño en función del ancho disponible del card
        final size = constraints.maxWidth * factor;

        return SizedBox(
          width: size,
          height: size,
          child: Lottie.asset(
            assetPath,
            fit: BoxFit.contain,
            repeat: false, // se reproduce una vez
            animate: true, // arranca animada
          ),
        );
      },
    );
  }
}
