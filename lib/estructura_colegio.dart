/*
 structura del módulo de colegio (perfil adulto)
1. Vista principal del colegio
Archivo: views/colegio/colegio_overview_view.dart
Función: Muestra tarjetas por niño con resumen escolar
Tiempo estimado: 1–2 días
Contenido:
- Nombre, avatar, curso
- Próximo examen
- Última nota
- Media general
- Botón “Ver perfil escolar”

2. Tarjeta por niño
Archivo: views/colegio/widgets/alumno_card.dart
Función: Componente visual para cada niño
Tiempo estimado: 0.5–1 día
Contenido:
- Datos básicos
- Resumen escolar
- Acción para abrir vista detallada

3. Alta automática del niño en colegio
Archivo: controllers/alumno_controller.dart
Función: Crear entrada en Firebase al registrar niño
Tiempo estimado: 0.5–1 día
Contenido:
- UID, nombre, curso
- Inicialización de asignaturas vacías

4. Vista detallada del perfil escolar
Archivo: views/colegio/perfil_escolar_view.dart
Función: Muestra asignaturas, exámenes, estadísticas
Tiempo estimado: 2–3 días
Contenido:
- Tarjetas por asignatura
- Historial de exámenes
- Estadísticas visuales

5. Tarjeta por asignatura
Archivo: views/colegio/widgets/asignatura_card.dart
Función: Muestra resumen por asignatura
Tiempo estimado: 1 día
Contenido:
- Nombre de asignatura
- Próximo examen
- Media actual
- Botón “Ver más”

6. Vista de estadísticas escolares
Archivo: views/colegio/estadisticas_escolares_view.dart
Función: Gráficas y evolución académica
Tiempo estimado: 2–3 días
Contenido:
- Media por asignatura
- Evolución temporal
- Comparativas

7. Modelos de datos
Archivos:
- models/alumno_model.dart
- models/asignatura_model.dart
- models/examen_model.dart
Función: Estructura de datos para Firebase
Tiempo estimado: 1 día
Contenido:
- Campos clave: nombre, UID, notas, fechas, medias

8. Controladores
Archivos:
- controllers/colegio_controller.dart
- controllers/asignatura_controller.dart
- controllers/estadisticas_controller.dart
Función: Lógica de carga, actualización y cálculo
Tiempo estimado: 2 días
Contenido:
- Cargar datos desde Firebase
- Calcular medias y evolución
- Validar entradas

9. Filtros en el calendario escolar
Archivo: views/calendario/calendario_escolar_view.dart
Función: Mostrar solo eventos escolares
Tiempo estimado: 1–2 días
Contenido:
- Filtro por tipo de evento (examen, excursión)
- Integración con calendario general

⏳ Total estimado: 11–16 días de trabajo efectivo

🧭 Orden recomendado de implementación
- AlumnoModel + alta automática al registrar niño
- ColegioOverviewView + AlumnoCard
- PerfilEscolarView + AsignaturaModel + AsignaturaCard
- ExamenModel + historial de exámenes
- EstadisticasEscolaresView + controlador de estadísticas
- Filtros en el calendario escolar

*/
