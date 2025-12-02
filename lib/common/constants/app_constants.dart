import 'dart:ui';



class AppConstants {
  // **************** ROLES ****************
  static const String rolAdmin = 'admin';
  static const String rolPadre = 'padre';
  static const String rolAdulto = 'adulto';
  static const String rolNino = 'niño';

  // **************** IDs DE USUARIOS (solo si son fijos) ****************
  static const String idAlex = 'alex';
  static const String idErik = 'erik';
  static const String idMama = 'mama';
  static const String idPapa = 'papa';

  static const List<String> idsNinos = [idAlex, idErik];

  // **************** NOMBRES DE USUARIOS (solo si son fijos) ****************
  static const String nombreAlex = 'Álex';
  static const String nombreErik = 'Erik';
  static const String nombreMama = 'Mamá';
  static const String nombrePapa = 'Papá';


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

  // **************** OTROS ****************
  static const int puntosPorDefecto = 0;

   // **************** FECHAS *****************
  static const Locale localeEs = Locale('es', 'ES');
  static const String formatoFecha = 'yyyy-MM-dd';

}