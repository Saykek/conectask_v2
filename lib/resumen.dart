/*
Resumen de la app de menú semanal:

- Modelo: MenuDiaModel con almuerzo, cena, recetaAlmuerzo, recetaCena
- Vista: ListView vertical con botón "Ver receta"
- Firebase:
  - Realtime Database: guarda menú y enlaces
  - Storage: subir PDFs, usar reglas públicas en /recetas/
- Errores resueltos:
  - Tipos Map<String, dynamic> vs Map<String, String>
- Siguientes pasos:
  - Subir PDFs
  - Mostrar recetas
  - Crear vista de edición
  - para crear menu que se pueda escribir... 
*/
/* MVC 
- CONFIGURACION OK
- MENU SEMANAL OK ( falta incluir recetas, foto...)
*/
/*                                                         *********** PENDIENTE *************

- Añadir para repetir las tareas X dias 1.5-2 horas
- Scroll horizontal en tareas
- Poner autocompletar en tareas y apartado de puntos. ✅
- Cambiar logo tareas de ver en calendario o seleccionar dias ✅
- Añadir para enlace PDF 30-45 min
- En los niños que solo se vean sus tareas ✅
- poner calendario en español y de lunes a domingo ✅
- Que no se puedan crear tareas en fechas anteriores 15-20 min
- Cambiar que salga el boton validar cuando sea adulto y no niño. ✅
- Q en validad por salga el nombre de quien valida.✅
- En el registro que no cuenten acentos 20-30 min
- Mostrar requisitos de contraseña al registrarse 30-45 min
- Misiones especiales: tareas con recompensas extra si se completan en grupo o en tiempo récord.2-3 horas
- Calendario visual de tareas: con colores por usuario y prioridad.2-3 horas
- Recordatorios automáticos: para tareas pendientes o próximas.2-3 horas
- Historial de tareas completadas: con filtros por fecha, tipo o responsable.1.5-2 horas
- horario en tareas? 30-45 min


🧠 Inteligencia y personalización
- Recomendaciones de tareas según hábitos: por ejemplo, si Alex siempre hace tareas por la tarde. 3-4 horas
- Estadísticas por usuario: tiempo medio de entrega, tareas favoritas, evolución de puntos. 2.-3 horas
- Temas visuales personalizados: cada niño elige su color, avatar o fondo. 1.5-2 horas

🔒 Seguridad y control
- Control parental: para validar tareas, limitar recompensas o ver actividad. 2-3 horas
- Bloqueo por PIN para recompensas sensibles: como ver TV o usar tablet.1-1.5 horas
- Historial de canjeos: para que los padres vean qué se ha usado y cuándo. 1-1.5 horas

🌐 Conectividad y multimedia
- Adjuntar fotos o vídeos a tareas: como prueba de que se hizo. 2-3 horas
- Enlaces a recursos educativos: PDFs, vídeos, juegos didácticos. 1.5-2 horas
- Modo offline: para que funcione sin conexión y sincronice después. 4 - 6 horas

🧩 Extras divertidos
- Mini juegos desbloqueables: al alcanzar ciertos niveles. 3-4 horas
- Sistema de “tienda” con recompensas virtuales: como cambiar el avatar, fondo, etc. 2.5-3 horas
- Mensajes motivadores automáticos: “¡Buen trabajo, Erik! Has subido de nivel 🎉” 1-1.5 horas





- Los colores de las tareas se tienen que poner aleatoriamente segun se crea usuario 30-45 min
- quitar insignias fijas de recompensas y que se puedan añadir nuevas desde firebase 2-4 horas
- Recompensas salgan usuarios reales ✅
- en recompensas perfil niño no se rellena la barra progresiva cuando tiene puntos✅
- crear boton cerrar sesion 20-30 min

Recomendación de orden para implementar
- ✅ Resumen de tareas por día 1-1.5 horas
- ✅ Sistema de puntos (motivador, visual)
- ✅ Autocompletar desde Firebase (mejora UX) ✅
- 🔁 Tareas recurrentes (más compleja, pero muy potente)
- 📆 Vista mensual (ideal para planificación) ✅
- 🔔 Notificaciones (requiere permisos y lógica) 2-3 horas
- 🧒 Modo infantil (puede ser parte del sistema de puntos)

*/

/*                                                   **********************  MEJORAS FUTURAS **********************

 - Opción para asignar tareas a varias personas. - Que se pueda seleccionar mas de un usuario en asignar.
 -
*/

 /*                            ******************* PROMPT **************************
 en mi proyecto Flutter con dart en vsc estoy haciendo una aplicación
 de gestión familiar, donde están los modulos de tareas, menú semanal, 
 colegio, casa, recomepensas, calendario, configuración... y un modo foto 
 (slide) para hacerlo modo cuadro digital. tengo creado el modulo de tareas,
  menú semanal, recompensas.. aunque no completos. te paso un resumen que 
  escribimos para que te hagas una idea. IMPORTANTE: uso modelo vista controlador.
   Uso Firebase con realtime y auth.  Tengo Home Assistant alojado en docker que usare para el modulo de casa.
    Sera una aplicacion que debe actualizarse en el momento porque se usara en moviles y web.
   Hay dos tipos de usuarios, admin con registro de email y los niños que los crearan los admin
   con un usuario y un pin. Las tareas otorgaran puntos que luego los niños podran canjear por recompensas. 
   En el menu semanal quiero añadir   un boton o algo para enlazar recetas que tendre alojadas en algun sitio ( aun por determinar).
   No quiero que me pongas nada de codigo hasta que te vaya dando el ok para que yo pueda ir probando todo.
   Los ultimos avances: 
        - al actualizar los puntos de una tarea se actualizan en firebase
        - Tareas con autocompletado y nueva base de datos en firebase para que no tenga que cargar todos los datos, solo titulo y puntos.
        - Las tareas marcan si estan hechas, pendiente o validadas ( solo para los niños)
        -pendiente en el modulo de colegio mostrar columnas. He creado una clase que se llama
        aula que llevara una foto de fondo de un aula, donde solo lo veran los niños, al pulsar
        la pizarra se mostraran los examenes, al pulsar la libreria se abre los logros o algo asi
        al pulsar en el globo terraqueo se abrira otra cosa.. pero en el movil no podra verse asi
        imagino...(POR AHORA ESTO LO VOY A DEJAR PARA LINEAS FUTURAS), 
        - ya se cogen los usuarios reales de la base de datos de realtime.
        -
        Fijate en los ✅ y asi sabras lo que llevo hecho.
    Necesito que me digas en que clase y lugar va cada parte de codigo que me proporciones. Paso por
    paso, y hasta que no te de el ok no me pongas nada.
   
   */