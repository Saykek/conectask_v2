import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';

class TarjetaAlumno extends StatelessWidget {
  final UserModel usuario;
  final VoidCallback onTap;

  const TarjetaAlumno({required this.usuario, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Text('📅 Próximo examen: —'),
            Text('📊 Última nota: —'),
            Text('📈 Media general: —'),
          ],
        ),
      ),
    );
  }
}
