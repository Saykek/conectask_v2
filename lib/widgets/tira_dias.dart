import 'package:flutter/material.dart';

class TiraDiasWidget extends StatelessWidget {
  final List<String> dias;
  final List<int> numeros;
  final String diaSeleccionado;
  final Function(String) onSelectDia;

  const TiraDiasWidget({
    super.key,
    required this.dias,
    required this.numeros,
    required this.diaSeleccionado,
    required this.onSelectDia,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final dia = dias[index];
          final numero = numeros[index];
          final letra = ['L','M','X','J','V','S','D'][index];
          final isSelected = dia == diaSeleccionado;

          return GestureDetector(
            onTap: () => onSelectDia(dia),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                children: [
                  Text(
                    letra,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                    child: Text(
                      numero.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
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