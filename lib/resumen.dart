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
/* *********** PENDIENTE *************

- Añadir para repetir las tareas X dias
- Poner autocompletar en tareas y apartado de puntos.
- Que se pueda seleccionar mas de un usuario en asignar.
- Cambiar logo tareas de ver en calendario o seleccionar dias
- Añadir para enlace PDF
- En los niños que solo se vean sus tareas
*/
/* en mi proyecto Flutter con dart en vsc estoy haciendo una aplicación
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
   No quiero que me pongas nada de codigo hasta que te vaya dando el ok para que yo pueda ir probando todo.*/