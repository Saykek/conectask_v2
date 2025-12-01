import 'package:conectask_v2/Utils/color_utils.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/widgets/tarjeta_base_colegio.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final esMovil = screenWidth < 600;

    final avatarRadius = (screenWidth * 0.04).clamp(20.0, 28.0);
    final iconSize = (screenWidth * 0.05).clamp(24.0, 40.0);
    final fontSizeTitulo =
        ((screenWidth * 0.035).clamp(16.0, 22.0)) * (esMovil ? 1.0 : 0.9);
    final fontSizeInfo =
        ((screenWidth * 0.025).clamp(12.0, 18.0)) * (esMovil ? 1.0 : 0.9);
    final spacing = (screenWidth * 0.02).clamp(8.0, 16.0);

    return TarjetaBaseColegio(
      color: colorUsuario,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ CLAVE anti-overflow
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre y avatar
          Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: colorUsuario,
                child: Text(
                  usuario.nombre[0],
                  style: TextStyle(
                    fontSize: avatarRadius,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Text(
                  usuario.nombre,
                  style: TextStyle(
                    fontSize: fontSizeTitulo,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: iconSize * 0.4),
            ],
          ),
          SizedBox(height: spacing * 1.5),

          _filaIconoTexto(
            iconPath: 'assets/iconos/examen.png',
            texto: 'Próximo examen: $proximoExamen',
            iconSize: iconSize,
            fontSize: fontSizeInfo,
            spacing: spacing,
          ),
          SizedBox(height: spacing / 1.5),

          _filaIconoTexto(
            iconPath: 'assets/iconos/nota.png',
            texto: 'Última nota: $ultimaNota',
            iconSize: iconSize,
            fontSize: fontSizeInfo,
            spacing: spacing,
          ),
          SizedBox(height: spacing / 1.5),

          _filaIconoTexto(
            iconPath: 'assets/iconos/media_notas.png',
            texto: 'Media general: $mediaNotas',
            iconSize: iconSize,
            fontSize: fontSizeInfo,
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  Widget _filaIconoTexto({
    required String iconPath,
    required String texto,
    required double iconSize,
    required double fontSize,
    required double spacing,
  }) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

