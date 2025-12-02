

class ColegioUtils {
  /// Devuelve la fecha del próximo examen futuro (más cercano a hoy).
  /// Puede usarse con los exámenes de una asignatura o con todos juntos.
  static String proximoExamen(List<Map<String, String>> examenes) {
    final ahora = DateTime.now();

    final futuros = examenes
        .map((ex) {
          final partes = (ex['fecha'] ?? '').split('/');
          if (partes.length != 3) return null;
          final dia = int.tryParse(partes[0]);
          final mes = int.tryParse(partes[1]);
          final anio = int.tryParse(partes[2]);
          if (dia == null || mes == null || anio == null) return null;
          return DateTime(anio, mes, dia);
        })
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
  /// Puede usarse con las notas de una asignatura o con todas juntas.
  static String ultimaNota(List<Map<String, String>> notas) {
    return notas.isNotEmpty ? notas.last['nota'] ?? '—' : '—';
  }

  /// Devuelve la media de notas.
  /// Puede usarse con las notas de una asignatura o con todas juntas.
  static String mediaNotas(List<Map<String, String>> notas) {
    if (notas.isEmpty) return '—';
    final media = notas
        .map((n) => double.tryParse(n['nota'] ?? '') ?? 0)
        .fold<double>(0, (a, b) => a + b) / notas.length;
    return media.toStringAsFixed(1);
  }
}