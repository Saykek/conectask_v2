class AppTareaFieldsConstants {
  // **************** CAMPOS PRINCIPALES ****************
  static const String id = 'id';
  static const String titulo = 'titulo';
  static const String descripcion = 'descripcion';
  static const String responsable = 'responsable';
  static const String fecha = 'fecha';
  static const String prioridad = 'prioridad';
  static const String estado = 'estado';
  static const String recompensa = 'recompensa';
  static const String validadaPor = 'validadaPor';
  static const String puntos = 'puntos';

  // **************** VALORES POR DEFECTO ****************
  // Estos se usan cuando el campo no existe en Firebase
  static const String prioridadPorDefecto = 'Media'; // ya tienes Alta/Media/Baja en AppConstants
  static const String estadoPorDefecto = 'pendiente'; // ya tienes estados en AppConstants

  // **************** NODOS RELACIONADOS ****************
  static const String tareasTitulos = 'tareasTitulos';
}