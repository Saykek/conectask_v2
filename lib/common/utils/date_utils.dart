import 'package:flutter/material.dart';
import 'package:conectask_v2/models/menu_dia_model.dart';

class DateUtils {
  /// Devuelve la lista de días de la semana en español (lunes a domingo).
  static List<String> diasSemana() {
    return ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
  }

  /// Devuelve la semana actual como lista de pares (letra, número del mes)
  static List<Map<String, dynamic>> semanaActual() {
    final hoy = DateTime.now();
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1)); // lunes
    return List.generate(7, (i) {
      final fecha = inicioSemana.add(Duration(days: i));
      final letra = ['L', 'M', 'X', 'J', 'V', 'S', 'D'][i];
      return {
        'letra': letra,
        'numero': fecha.day,
        'nombre': diasSemana()[i],
        'fecha': fecha,
      };
    });
  }

  /// Convierte un texto a capitalizado (primer carácter en mayúscula).
  static String ponerMayuscula(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }

  /// Devuelve el nombre del día actual en español.
  static String diaActual() {
    final idx = DateTime.now().weekday; // 1=lunes ... 7=domingo
    return diasSemana()[idx - 1];
  }

  /// Devuelve todos los días del mes como lista de mapas.
  static List<Map<String, dynamic>> diasDelMes(DateTime fecha) {
    final primerDia = DateTime(fecha.year, fecha.month, 1);
    final ultimoDia = DateTime(fecha.year, fecha.month + 1, 0);

    return List.generate(ultimoDia.day, (i) {
      final dia = primerDia.add(Duration(days: i));
      final letra = ['L', 'M', 'X', 'J', 'V', 'S', 'D'][dia.weekday - 1];
      return {
        'letra': letra,
        'numero': dia.day,
        'nombre': diasSemana()[dia.weekday - 1],
        'fecha': dia,
      };
    });
  }

  /// Devuelve la fecha en formato yyyy-MM-dd (ej: 2025-11-19)
  static String formatearFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  /// Devuelve una lista con los próximos [cantidad] días a partir de [desde].
  static List<Map<String, dynamic>> proximosDias(DateTime desde, int cantidad) {
    return List.generate(cantidad, (i) {
      final dia = desde.add(Duration(days: i));
      final letra = ['L', 'M', 'X', 'J', 'V', 'S', 'D'][dia.weekday - 1];
      return {
        'letra': letra,
        'numero': dia.day,
        'nombre': diasSemana()[dia.weekday - 1],
        'fecha': dia,
      };
    });
  }

  /// Busca el índice de un día dentro de una lista de MenuDiaModel.
  /// Devuelve -1 si no se encuentra.
  static int buscarIndiceDia(List<MenuDiaModel> menu, DateTime dia) {
    final selStr = formatearFecha(dia);
    return menu.indexWhere((d) => d.fecha == selStr);
  }

  /// Scroll al día seleccionado (con animación)
  static void scrollToDia({
    required List<MenuDiaModel> menu,
    required DateTime dia,
    required ScrollController controller,
    double alturaCard = 115.0,
  }) {
    final idxSel = buscarIndiceDia(menu, dia);
    print("📌 scrollToDia -> dia: $dia, idxSel: $idxSel");

    if (idxSel >= 0) {
      final offset = idxSel * alturaCard;
      print("📌 offset calculado: $offset");
      controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      print("❌ No se encontró índice para $dia");
    }
  }

  /// Scroll al día actual (sin animación, directo)
  static void scrollToHoy({
    required List<MenuDiaModel> menu,
    required ScrollController controller,
    double alturaCard = 115.0,
  }) {
    final hoy = DateTime.now();
    final idxHoy = menu.indexWhere((d) {
      final fechaObj = DateTime.parse(d.fecha);
      return fechaObj.year == hoy.year &&
             fechaObj.month == hoy.month &&
             fechaObj.day == hoy.day;
    });

    print("📌 scrollToHoy -> idxHoy: $idxHoy, llamada=${DateTime.now()}");

    if (idxHoy >= 0) {
      final offset = idxHoy * alturaCard;
      controller.jumpTo(offset); // 👈 directo, sin animación
    } else {
      print("❌ No se encontró índice para hoy");
    }
  }

  /// Convierte una fecha en formato dd/MM/yyyy a DateTime
  static DateTime? parsearFechaDDMMYYYY(String fecha) {
    try {
      final partes = fecha.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final anio = int.parse(partes[2]);
      return DateTime(anio, mes, dia);
    } catch (_) {
      return null;
    }
  }

  /// Devuelve la fecha del próximo examen futuro (más cercano a hoy).
  static String proximoExamen(List<Map<String, String>> examenes) {
    final ahora = DateTime.now();

    final futuros = examenes
        .map((ex) => parsearFechaDDMMYYYY(ex['fecha'] ?? ''))
        .where((f) => f != null && f.isAfter(ahora))
        .toList();

    if (futuros.isEmpty) return '—';

    futuros.sort(); // ordena por fecha
    final siguiente = futuros.first!;
    return "${siguiente.day.toString().padLeft(2, '0')}/"
           "${siguiente.month.toString().padLeft(2, '0')}/"
           "${siguiente.year}";
  }
}