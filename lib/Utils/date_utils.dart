class DateUtils {
  /// Devuelve la lista de días de la semana en español (lunes a domingo).
  static List<String> diasSemana() {
    return ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];
  }

  /// Devuelve la semana actual como lista de pares (letra, número del mes)
  static List<Map<String, dynamic>> semanaActual() {
    final hoy = DateTime.now();
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1)); // lunes
    return List.generate(7, (i) {
      final fecha = inicioSemana.add(Duration(days: i));
      final letra = ['L','M','X','J','V','S','D'][i];
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
  static List<Map<String, dynamic>> diasDesdeHoyHastaFinMes() {
  final hoy = DateTime.now();
  final ultimoDia = DateTime(hoy.year, hoy.month + 1, 0);

  return List.generate(ultimoDia.day - hoy.day + 1, (i) {
    final dia = hoy.add(Duration(days: i));
    final letra = ['L','M','X','J','V','S','D'][dia.weekday - 1];
    return {
      'letra': letra,
      'numero': dia.day,
      'nombre': diasSemana()[dia.weekday - 1],
      'fecha': dia,
    };
  });
}
}