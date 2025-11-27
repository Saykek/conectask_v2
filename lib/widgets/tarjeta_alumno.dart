import 'package:conectask_v2/Utils/color_utils.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';

class TarjetaAlumno extends StatelessWidget {
  final UserModel usuario;
  final String proximoExamen;
  final String ultimaNota;
  final String mediaNotas;
  final VoidCallback onTap;

  const TarjetaAlumno({
    required this.usuario,
    required this.proximoExamen,
    required this.ultimaNota,
    required this.mediaNotas,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorUsuario = obtenerColorUsuario(usuario);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorUsuario.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorUsuario),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 224, 224, 224),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 24, child: Text(usuario.nombre[0])),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    usuario.nombre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/iconos/examen.png', width: 40, height: 40),
                    const SizedBox(width: 12),
                    Text(
                      'Próximo examen: $proximoExamen',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Image.asset('assets/iconos/nota.png', width: 40, height: 40),
                    const SizedBox(width: 12),
                    Text(
                      'Última nota: $ultimaNota',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Image.asset('assets/iconos/media_notas.png', width: 40, height: 40),
                    const SizedBox(width: 12),
                    Text(
                      'Media general: $mediaNotas',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}