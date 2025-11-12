import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NavegacionFecha extends StatelessWidget {
  final DateTime fechaActual;
  final void Function(DateTime) onFechaCambiada;

  const NavegacionFecha({
    super.key,
    required this.fechaActual,
    required this.onFechaCambiada,
  });

  @override
  Widget build(BuildContext context) {
    final fechaTexto = DateFormat('EEEE, d MMMM', 'es_ES').format(fechaActual);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
  "Tareas del ${DateFormat('EEEE d MMMM', 'es_ES').format(fechaActual)}",
  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
),
        Container(
  height: 1,
  color: const Color.fromARGB(255, 114, 165, 224),
),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final nuevaFecha = fechaActual.subtract(const Duration(days: 1));
                onFechaCambiada(nuevaFecha);
              },
            ),
            const SizedBox(width: 16),
            Text(
              DateFormat('dd/MM/yyyy').format(fechaActual),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                final nuevaFecha = fechaActual.add(const Duration(days: 1));
                onFechaCambiada(nuevaFecha);
              },
            ),
          ],
        ),
      ],
    );
  }
}
