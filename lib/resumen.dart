/*
Resumen de la app de gestion familiar:

************** Modelo: 
- MenuDiaModel con comida, cena, recetacomida, recetaCena
- Comida model
- Configuracion model
- Examen model
- recompensa model
- tarea model
- user model

************** Vista: 
- aula view
- calendar view
- colegio view
- configuracion view
- crear nino view
- debug view
- home view
- login view
- menu semanal edit view
- menu semanal view 
- menu semanal detalle
- prueba imagen view
- recompensa add view
- recompensa detail view
- recompensas view
- register view
- task add view 
- task detail view
- task edit view
- task view 

************** Controllers:
- colegio controller
- configuracion controller
- login controller
- menu semanal controller
- recompensa controller
- tarea controller
- usuario controller

************** Services
- configuracion service
- menu semanal service
- recompensa service
- tarea service
- user service
- receta service



**************** Common
- constant
- theme
- utils
- widgets

    *************** Constants
- app_constants
- app_fields_constants
- app_firebase_constants
- app_icons_constants
- app_messages_ constants
- app_routes_constants
- app_theme_constants
- app_urls_constants
- constants

    *************** Utils
- color utils
- date utils
- text utils
- usuarios local

    *************** widgets
- lista recompensa
- navegacion
- resumen recompensas
- tarjeta alumno
- tarea asignatura
- temporizador estudio
- autocompletar
- menu card
- animacion brillo texto
- animacion toogle
- receta_modulo -> clase comun para mostrar animacion en cards y demáss


    **************** theme
- app theme
- colegio theme


- Firebase:
  - Realtime Database: guarda menú
  - guarda enlaces ?
  - Guarda usuarios
  - Guarda tareas
  - Guarda recompensas

- Errores resueltos:
  - Tipos Map<String, dynamic> vs Map<String, String>
  - scroll horizontal



                                                         *********** PENDIENTE *************

** pendiente de poner el icono de la app en ios. https://yayocode.com/es/codelabs/flutter/change_the_app_launcher_icon_on_flutter_without_using_any_package/
- Los colores de las tareas se tienen que poner aleatoriamente segun se crea usuario 30-45 min ✅
- Recompensas salgan usuarios reales ✅
- en recompensas perfil niño no se rellena la barra progresiva cuando tiene puntos✅
- crear boton cerrar sesion 20-30 min ✅
- crear niños desde config y editarlos ✅
- Scroll horizontal en tareas ✅
- Poner autocompletar en tareas y apartado de puntos. ✅
- Cambiar logo tareas de ver en calendario o seleccionar dias ✅
- En los niños que solo se vean sus tareas ✅
- poner calendario en español y de lunes a domingo ✅
- Cambiar que salga el boton validar cuando sea adulto y no niño. ✅
- Q en validad por salga el nombre de quien valida.✅
- Desbordamiento en todas las vistas de colegio ✅
- en menu semanal guardo receta pero no se actualiza en la pantalla edit, sino que tengo que salir y volver a entrar. ✅
- quitar modulo de configuracion y casa del home del niño ✅
- en menu semanal detalle ingredientes, receta, notas no se guardan, no tiene funcionalidad.
- Añadir para enlace PDF 30-45 min
- Añadir para repetir las tareas X dias 1.5-2 horas
- Que no se puedan crear ni editar tareas en fechas anteriores 15-20 min con validacion por si lo ponen manual ✅
- En el registro que no cuenten acentos 20-30 min
- Mostrar requisitos de contraseña al registrarse 30-45 min
- Misiones especiales: tareas con recompensas extra si se completan en grupo o en tiempo récord.2-3 horas
- Calendario visual de tareas: con colores por usuario y prioridad.2-3 horas
- Recordatorios automáticos: para tareas pendientes o próximas.2-3 horas
- Historial de tareas completadas: con filtros por fecha, tipo o responsable.1.5-2 horas
- horario en tareas? 30-45 min
- quitar insignias fijas de recompensas y que se puedan añadir nuevas desde firebase 2-4 horas
- al validar una tarea los puntos se suman en un sitio pero en otro no
- Una vez que validas la tarea si luego la dejas como no hecha al volver a darla ya sale validad, no pasa por el paso
intermedio, y los puntos siguen sumandos.
- Boton de claro oscurso se vuelve, hace animacion.
- acceso niños muy abajo IMPORTANTE!!!
- editar y eliminar recompensas no se puede
- navegacion.dart poner colores de theme
- HOME ASSISTANT : Versión mínima (solo formulario + carga de panel Lovelace): 4–6 días.
• 	Versión completa (con roles, aparatos configurables y persistencia en Firebase): 10–15 días.
- si añades puntos desde configuracion se borran los acumulados del usuario
- los nombres de usuarios en tareas no se diferencian bien 
- IMPORTANTE: Duplicidad de codigo de no poder seleccionar fecha anterior en add y edit tarea.
- en tareas al entrar, buscas un dia y sales, al entrar se queda en el dia buscado.
- EDITAR MENU MUUUUY LENTOOOO

** los colores de los usuarios no se pq 1-12-2025 se han modificado, ahora si no existe el color en configuracion no da error
al entrar a editar el perfil del niño **


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


Recomendación de orden para implementar
- ✅ Resumen de tareas por día 1-1.5 horas
- ✅ Sistema de puntos (motivador, visual)
- ✅ Autocompletar desde Firebase (mejora UX) ✅
- 🔁 Tareas recurrentes (más compleja, pero muy potente)
- 📆 Vista mensual (ideal para planificación) ✅
- 🔔 Notificaciones (requiere permisos y lógica) 2-3 horas
- 🧒 Modo infantil (puede ser parte del sistema de puntos)

*/
   /*                                               *********************** CONSTANTES **************************
    task_view ✅
    task_edit_view ✅
    task_add_view ✅
    tarea service ✅
    tarea_model ✅
    home_assistant_view ✅
    home_assistant_controller ✅
    home_assistant_model ✅
    home_assistant_service ✅
    register_view ✅
    recompensas_view ✅
    recompensas_detail_view ✅
    recompensas_add_view ✅
    menu_semanal_view ✅
    menu_semanal_edit_view ✅
    menu_semanal_detalle_view ✅
    configuracion_model ✅
    login_view ✅
    home_view ✅
    colegio_view ✅
    colegio_perfil_view ✅
    colegio_asignatura_view ✅
    usuario controller a medias
    
      
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
        - Scroll en tareas y usuarios.
        - Modulo menu bastante avanzado ya tengo la comida y cena en card (widget) con dos platos., muestra foto si la hay, puedo acceder a receta online..
        pantalla de edit con dos platos y sus iconos, falta que la tira de calendario al pulsar el dia se vaya a ese exactamente.
        - En pantalla recompensas se pueden canjear recomenpensas reales, ya resta puntos, pero no desaparecen al momento de la lista, tienes que salir y entrar. 

        Muy Importante ** Fijate en los ✅ y asi sabras lo que llevo hecho.
    Necesito que me digas en que clase y lugar va cada parte de codigo que me proporciones. Paso por
    paso, y hasta que no te de el ok no me pongas nada.
   
   */