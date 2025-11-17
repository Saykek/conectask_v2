import 'package:flutter/material.dart';

class TiraDiasWidget extends StatelessWidget {
  final List<DateTime> fechas;
  final DateTime diaSeleccionado;
  final Function(DateTime) onSelectDia;

  const TiraDiasWidget({
    super.key,
    required this.fechas,
    required this.diaSeleccionado,
    required this.onSelectDia,
  });

  bool esHoy(DateTime fecha) {
    final hoy = DateTime.now();
    return fecha.day == hoy.day &&
        fecha.month == hoy.month &&
        fecha.year == hoy.year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fechas.length,
        itemBuilder: (context, index) {
          final fecha = fechas[index];
          final letra = ['L','M','X','J','V','S','D'][fecha.weekday - 1];
          final isSelected = fecha.day == diaSeleccionado.day &&
              fecha.month == diaSeleccionado.month &&
              fecha.year == diaSeleccionado.year;

          return GestureDetector(
            onTap: () => onSelectDia(fecha),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                children: [
                  Text(letra, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: esHoy(fecha)
                        ? Colors.redAccent
                        : (isSelected ? Colors.blueAccent : Colors.grey.shade300),
                    child: Text(
                      fecha.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (esHoy(fecha) || isSelected)
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}