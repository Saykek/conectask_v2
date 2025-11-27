import 'package:conectask_v2/Utils/date_utils.dart';

class ColegioUtils {
  /// Devuelve la fecha del próximo examen futuro (más cercano a hoy).
  static String proximoExamen(List<Map<String, String>> examenes) {
    final ahora = DateTime.now();

    final futuros = examenes
        .map((ex) => DateUtils.parsearFechaDDMMYYYY(ex['fecha'] ?? ''))
        .where((f) => f != null && f.isAfter(ahora))
        .toList();

    if (futuros.isEmpty) return '—';

    futuros.sort();
    final siguiente = futuros.first!;
    return "${siguiente.day.toString().padLeft(2, '0')}/"
           "${siguiente.month.toString().padLeft(2, '0')}/"
           "${siguiente.year}";
  }

  /// Devuelve la última nota registrada.
  static String ultimaNota(List<Map<String, String>> notas) {
    return notas.isNotEmpty ? notas.last['nota'] ?? '—' : '—';
  }

  /// Devuelve la media de notas.
  static String mediaNotas(List<Map<String, String>> notas) {
    if (notas.isEmpty) return '—';
    final media = notas
        .map((n) => double.tryParse(n['nota'] ?? '') ?? 0)
        .fold<double>(0, (a, b) => a + b) / notas.length;
    return media.toStringAsFixed(1);
  }
}