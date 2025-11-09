class TextUtils {
  /// Convierte la primera letra de un texto a mayúscula.
  static String ponerMayuscula(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }

  /// Convierte todo el texto a minúsculas y luego la primera letra a mayúscula.
  static String ponerMayusculaNormalizada(String texto) {
    if (texto.isEmpty) return texto;
    texto = texto.toLowerCase();
    return texto[0].toUpperCase() + texto.substring(1);
  }
}
