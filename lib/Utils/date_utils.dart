class DateUtils {
  /// Devuelve la lista de días de la semana en español.
  static List<String> diasSemana() {
    return [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
  }

  /// Convierte un día en español a su versión capitalizada.
  static String ponerMayuscula(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
}
