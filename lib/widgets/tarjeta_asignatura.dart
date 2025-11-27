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
                  final iconColor = ColegioTheme.colorIconoPorAsignatura(nombre);
                  return Icon(icono, size: iconSize, color: iconColor);
                },
              ),
              const SizedBox(height: 8),
              Text(
                nombre,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // 🔹 Ahora usamos los valores que recibimos en el constructor
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/iconos/examen.png', width: 30, height: 30),
                    const SizedBox(width: 12),
                    Text(
                      'Próximo examen: $proximoExamen',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/iconos/nota.png', width: 30, height: 30),
                    const SizedBox(width: 12),
                    Text(
                      'Última nota: $ultimaNota',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/iconos/media_notas.png', width: 30, height: 30),
                    const SizedBox(width: 12),
                    Text(
                      'Media general: $mediaNotas',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}