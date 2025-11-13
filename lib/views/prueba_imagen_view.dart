import 'package:flutter/material.dart';

class PruebaImagenView extends StatelessWidget {
  const PruebaImagenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de imagen')),
      body: Center(child: Image.asset('assets/images/fondo_aula.png')),
    );
  }
}
