import 'package:conectask_v2/theme/colegio_theme.dart';
import 'package:flutter/material.dart';

class TarjetaAsignatura extends StatelessWidget {
  final String nombre;
  final IconData icono;
  final String proximoExamen;
  final String mediaNotas;
  final String ultimaNota;
  final VoidCallback? onTap;

  const TarjetaAsignatura({
    required this.nombre,
    required this.icono,
    required this.proximoExamen,
    required this.mediaNotas,
    required this.ultimaNota,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorFondo = ColegioTheme.colorPorAsignatura(nombre);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colorFondo,
        shape: Theme.of(context).cardTheme.shape,
        elevation: Theme.of(context).cardTheme.elevation,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final iconSize = constraints.maxWidth * 0.25;
                  final iconColor = ColegioTheme.colorIconoPorAsignatura(
                    nombre,
                  );

                  return Icon(icono, size: iconSize, color: iconColor);
                },
              ),
              const SizedBox(height: 8),
              Text(
                nombre,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('📅 Próximo examen: $proximoExamen'),
              Text('📊 Media de notas: $mediaNotas'),
              Text('📈 Última nota: $ultimaNota'),
            ],
          ),
        ),
      ),
    );
  }
}
