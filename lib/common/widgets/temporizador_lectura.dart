import 'dart:async';
import 'package:flutter/material.dart';

class TemporizadorLectura extends StatefulWidget {
  const TemporizadorLectura({super.key});

  @override
  State<TemporizadorLectura> createState() => _TemporizadorLecturaState();
}

class _TemporizadorLecturaState extends State<TemporizadorLectura> {
  int segundos = 0;
  Timer? timer;
  bool enMarcha = false;

  void iniciarTemporizador() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        segundos++;
      });
    });
    setState(() {
      enMarcha = true;
    });
  }

  void detenerTemporizador() {
    timer?.cancel();
    setState(() {
      enMarcha = false;
    });
  }

  @override
  void dispose() {
    detenerTemporizador();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutos = (segundos / 60).floor();
    final restoSegundos = segundos % 60;

    return Scaffold(
      appBar: AppBar(title: const Text('Temporizador de lectura')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutos:${restoSegundos.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            enMarcha
                ? ElevatedButton.icon(
                    onPressed: detenerTemporizador,
                    icon: const Icon(Icons.pause),
                    label: const Text('Detener'),
                  )
                : ElevatedButton.icon(
                    onPressed: iniciarTemporizador,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                  ),
          ],
        ),
      ),
    );
  }
}