/// Clase para centralizar todas las constantes de la app
class Constantes {
  // **************** ROLES ****************
  static const String rolAdmin = 'admin';
  static const String rolPadre = 'padre';
  static const String rolAdulto = 'adulto';
  static const String rolNino = 'niño';

  // IDs de niños fijos (si los usas para validaciones)
  static const String idAlex = 'alex';
  static const String idErik = 'erik';
  static const List<String> idsNinos = [idAlex, idErik];

  // **************** PRIORIDADES ****************
  static const String prioridadAlta = 'Alta';
  static const String prioridadMedia = 'Media';
  static const String prioridadBaja = 'Baja';
  static const List<String> prioridades = [
    prioridadAlta,
    prioridadMedia,
    prioridadBaja,
  ];

  // **************** ESTADOS DE TAREA ****************
  static const String estadoPendiente = 'pendiente';
  static const String estadoHecha = 'hecha';
  static const String estadoValidada = 'validada';

  // **************** MENSAJES ****************
  static const String msgCampoObligatorio = 'Campo obligatorio';
  static const String msgCompletaCampos = 'Completa todos los campos';
  static const String msgErrorActualizar = 'Error al actualizar tarea';
  static const String msgTareaGuardada = 'Tarea añadida correctamente';
  static const String msgTareaActualizada = 'Tarea actualizada correctamente';
  static const String msgTareaEliminada = 'Tarea eliminada correctamente';

  // **************** DÍAS DE LA SEMANA ****************
  static const List<String> diasSemana = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo'
  ];
  static const List<String> letrasDias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  // **************** COLORES ****************
  static const colorPendiente = 0xFF9E9E9E; // gris
  static const colorHecha = 0xFFFFC107; // ámbar
  static const colorValidada = 0xFF4CAF50; // verde

  // **************** OTROS ****************
  static const int puntosPorDefecto = 0;
}
