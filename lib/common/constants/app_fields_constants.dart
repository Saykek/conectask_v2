class AppFieldsConstants {
  // **************** CAMPOS PRINCIPALES ****************
  static const String saludo = 'Bienvenido, ';
  static const String id = 'id';
  static const String titulo = 'título';
  static const String descripcion = 'descripción';
  static const String sinDescripcion = 'Sin Descripción';
  static const String sinAsignar = 'Sin asignar';
  static const String noEspecificados = 'No especificados';
  static const String noDisponible = 'No disponible';
  static const String responsable = 'responsable';
  static const String registroUsuario = 'Registro de usuario';
  static const String fecha = 'fecha';
  static const String prioridad = 'prioridad';
  static const String estado = 'estado';
  static const String campoObligatorio = 'Campo obligatorio';
  static const String escribeNombre = 'Escribe un nombre';
  static const String mail = 'mail';
  static const String contrasenia = 'contraseña';
  static const String registrar = 'Registrar';
  static const String todos = 'Todos';
  static const String entrar = 'Entrar';
  static const String eliminar = 'Eliminar';
  static const String cancelar = 'Cancelar';
  static const String guardar = 'Guardar';
  static const String anadir = 'Añadir';
  static const String anadido = 'añadido';
  static const String guardarCambios = 'Guardar cambios';
  static const String accesoNinos = 'Acceso para niños';
  static const String inicioSesion = ' Iniciar sesión';
  static const String sinCuenta = '¿No tienes cuenta? Regístrate';
  static const String editarNino = 'Editar perfil de niño' ;
  static const String crearNino = 'Crear perfil de niño';
  static const String cerrarSesion = '¿Cerrar sesión?';
  static const String modoFotos = 'Modo Fotos';
  static const String tareas = 'Tareas';
  static const String colegio = 'Colegio';
  static const String casa = 'Casa';
  static const String calendario = 'Calendario';
  static const String perfilEscolar = 'Perfil escolar de ';
  static const String examenes = 'Exámenes';
  static const String notaMin = 'nota';
  static const String nota = 'Nota';
  static const String calendarioFamiliar = 'Calendario Familiar';
 

  //static const String nombre = 'Nombre';

  static const String recompensa = 'recompensa';
  static const String recompensas = 'Recompensas';
  static const String recompensasMin = 'recompensas';
  static const String validadaPor = 'validadaPor';
  static const String puntos = 'puntos';
  static const String anadirNuevaRecompensa = 'Añadir nueva recompensa';
  static const String anadirRecompensa = 'Añadir recompensa';
  static const String editarRecompensa = 'Editar recompensa';
  static const String eliminarRecompensa = 'Eliminar recompensa';
  static const String canjearRecompensa = 'Canjear Recompensa';
  static const String guardarRecompensa = 'Guardar recompensa';
  static const String recompensasDisponibles = '🎁 Recompensas disponibles:';
  static const String descripcionIcono = '📝 Descripción:';
  static const String visibleNinos = 'Visible para los niños';

  static const String menuSemanal = 'Menú Semanal';
  static const String editarMenu = 'Editar Menú ';
  static const String guardarMenu = 'Guardar menú';
  static const String detalleMenu = 'Detalle del menú';
  static const String anadirReceta = 'Añadir receta';
  static const String editarEnlaceReceta = 'Editar enlace de receta';
  static const String anadirFotoReceta = 'Añadir foto de receta';
  static const String primerPlato = '1er plato';
  static const String segundoPlato = '2º plato';
  static const String comida = 'Comida';
  static const String comidas = 'Comidas';
  static const String cena = 'Cena';
  static const String cenas = 'Cenas';
  static const String ingredientes = 'Ingredientes';
  static const String ingredientesMin = 'ingredientes';
  static const String receta = 'Receta';
  static const String recetaMin = 'receta';

  static const String notas = 'Notas';
  static const String notasMin = 'notas';
  static const String sinNotas  = 'Sin notas';
  static const String pizarra = 'Pizarra';
  static const String temporizador = 'Temporizador';

  

  // **************** TOOLTIPS Y HINT TEXT****************
  static const String toolEditarMenu = 'Editar menú';
  static const String toolEditarEnlace = 'Editar enlace receta';
  static const String toolAnadirFoto = 'Añadir foto (URL)';
  static const String toolanadirIngredientes = 'Añadir ingredientes';
  static const String toolAnadirNotas = 'Añadir notas';
  static const String toolcerrarSesion = 'Cerrar sesión';

  static const String hintHttp = 'https://...';
  static const String hintEscribeAqui = 'Escribe aquí tu ';

  // **************** LABELS DE FORMULARIOS ****************
  static const String labelTitulo = 'Título';
  static const String labelusuario = 'usuario';
  static const String labelEmail = 'Email';
  static const String labelContrasenia = 'Contraseña';
  static const String lableAccesoNinos = 'Acceso para niños';
  static const String labelNivel = 'Nivel';
  static const String labelVolverAdulto = 'Volver a la sesión de adulto';
  static const String labelPin = 'PIN';
  static const String labelDescripcion = 'Descripción';
  static const String labelFecha = 'Fecha';
  static const String labelAsignarA = 'Asignar a';
  static const String labelPrioridad = 'Prioridad';
  static const String labelPuntos = 'Puntos';
  static const String labelPuntosRcomepensa = 'Puntos de recompensa';
  static const String labelNombre = 'Nombre';
  static const String labelCoste = 'Coste en puntos';
  static const String labelComidas = 'Comidas';
  static const String labelCenas = 'Cenas';
  static const String labelDia = 'Día';
  static const String labelIconoComida = '🍽️';
  static const String labelIconoNoche = "🌙";

  // **************** VALORES POR DEFECTO ****************
  // Estos se usan cuando el campo no existe en Firebase
  static const String prioridadPorDefecto = 'Media'; //  Alta/Media/Baja en AppConstants
  static const String estadoPorDefecto = 'pendiente'; // estados en AppConstants

  // **************** NODOS RELACIONADOS ****************
  static const String tareasTitulos = 'tareasTitulos';
}