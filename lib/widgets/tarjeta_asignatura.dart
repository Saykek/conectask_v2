import 'package:conectask_v2/theme/colegio_theme.dart';
import 'package:flutter/material.dart';
import 'package:conectask_v2/widgets/tarjeta_base_colegio.dart';


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
    final colorIcono = ColegioTheme.colorIconoPorAsignatura(nombre);

    // Tamaños fijos máximos
    const double iconSizeMax = 50;
    const double fontSizeTituloMax = 18;
    const double fontSizeInfoMax = 14;
    const double spacingMax = 12;

    return TarjetaBaseColegio(
      color: colorFondo,
      onTap: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: iconSizeMax, color: colorIcono),
          const SizedBox(height: spacingMax / 2),
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: fontSizeTituloMax,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: spacingMax),

          // PRÓXIMO EXAMEN
          _filaIconoTexto('assets/iconos/examen.png', 'Próximo examen: $proximoExamen', fontSizeInfoMax, spacingMax),
          const SizedBox(height: spacingMax / 2),

          // ÚLTIMA NOTA
          _filaIconoTexto('assets/iconos/nota.png', 'Última nota: $ultimaNota', fontSizeInfoMax, spacingMax),
          const SizedBox(height: spacingMax / 2),

          // MEDIA GENERAL
          _filaIconoTexto('assets/iconos/media_notas.png', 'Media general: $mediaNotas', fontSizeInfoMax, spacingMax),
        ],
      ),
    );
  }

  Widget _filaIconoTexto(String iconPath, String texto, double fontSize, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, width: fontSize + 6, height: fontSize + 6),
        SizedBox(width: spacing / 2),
        Flexible(
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
