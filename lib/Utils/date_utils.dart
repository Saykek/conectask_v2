class DateUtils {
  /// Devuelve la lista de días de la semana en español (lunes a domingo).
  static List<String> diasSemana() {
    return ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];
  }

  /// Devuelve la semana actual como lista de pares (letra, número del mes)
  static List<Map<String, dynamic>> semanaActual() {
    final hoy = DateTime.now();
    // Lunes = 1, Domingo = 7
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));
    return List.generate(7, (i) {
      final fecha = inicioSemana.add(Duration(days: i));
      final letra = ['L','M','X','J','V','S','D'][i];
      return {
        'letra': letra,
        'numero': fecha.day,
        'nombre': diasSemana()[i],
      };
    });
  }


  /// Convierte un texto a capitalizado (primer carácter en mayúscula).
  static String ponerMayuscula(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
  static String diaActual() {
  final idx = DateTime.now().weekday; // 1=lunes ... 7=domingo
  return diasSemana()[idx - 1];
}
}