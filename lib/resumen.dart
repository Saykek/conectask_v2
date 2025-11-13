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

- Añadir para repetir las tareas X dias
- Poner autocompletar en tareas y apartado de puntos. ✅
- Cambiar logo tareas de ver en calendario o seleccionar dias ✅
- Añadir para enlace PDF
- En los niños que solo se vean sus tareas ✅
- poner calendario en español y de lunes a domingo ✅
- Que no se puedan crear tareas en fechas anteriores
- Cambiar que salga el boton validar cuando sea adulto y no niño. ✅
- Q en validad por salga el nombre de quien valida.
- En el registro que no cuenten acentos
- Los colores de las tareas se tienen que poner aleatoriamente segun se crea usuario
- quitar insignias fijas de recompensas y que se puedan añadir nuevas desde firebase
- Recompensas salgan usuarios reales
- en recompensas perfil niño no se rellena la barra progresiva cuando tiene puntos
- crear boton cerrar sesion

Recomendación de orden para implementar
- ✅ Resumen de tareas por día (muy fácil, útil ya)
- ✅ Sistema de puntos (motivador, visual)
- ✅ Autocompletar desde Firebase (mejora UX) ✅
- 🔁 Tareas recurrentes (más compleja, pero muy potente)
- 📆 Vista mensual (ideal para planificación) ✅
- 🔔 Notificaciones (requiere permisos y lógica)
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
        imagino...
    Necesito que me digas en que clase y lugar va cada parte de codigo que me proporciones. Paso por
    paso, y hasta que no te de el ok no me pongas nada.
   
   */