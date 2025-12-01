import 'package:flutter/material.dart';
import '../models/asignatura_model_mock.dart';

class AsignaturaServiceMock {
  static List<AsignaturaModelMock> obtenerAsignaturas() {
    return [
      AsignaturaModelMock(
        nombre: 'Matemáticas',
        icono: Icons.calculate,
        examenes: [
          {'titulo': 'Examen Álgebra', 'fecha': '12/12/2025'},
          {'titulo': 'Examen Geometría', 'fecha': '15/01/2026'},
        ],
        notas: [
          {'titulo': 'Examen Álgebra', 'nota': '7.5', 'fecha': '12/12/2025'},
          {'titulo': 'Examen Geometría', 'nota': '8.0', 'fecha': '15/01/2026'},
        ],
        excursiones: [],
      ),
      AsignaturaModelMock(
        nombre: 'Lengua',
        icono: Icons.menu_book,
        examenes: [
          {'titulo': 'Examen Literatura', 'fecha': '15/09/2025'},
          {'titulo': 'Examen unidad 4', 'fecha': '22/10/2025'},
          {'titulo': 'Examen unidad 6', 'fecha': '22/01/2026'},
        ],
        notas: [
          {'titulo': 'Examen Literatura', 'nota': '7.0', 'fecha': '15/09/2025'},
          {'titulo': 'Examen unidad 4', 'nota': '5.4', 'fecha': '22/10/2025'},
        ],
        excursiones: [
          {'titulo': 'Teatro Clásico', 'fecha': '12/02/2026'},
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Ciencias',
        icono: Icons.eco,
        examenes: [
          {'titulo': 'Examen Biología', 'fecha': '18/01/2026'},
        ],
        notas: [
          {'titulo': 'Examen Biología', 'nota': '8.5', 'fecha': '18/01/2026'},
        ],
        excursiones: [
          {'titulo': 'Museo de Ciencias', 'fecha': '20/12/2025'}, 
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Inglés',
        icono: Icons.language,
        examenes: [
          {'titulo': 'Examen Grammar', 'fecha': '30/01/2026'},
        ],
        notas: [
          {'titulo': 'Examen Grammar', 'nota': '9.0', 'fecha': '30/01/2026'},
        ],
        excursiones: [
          {'titulo': 'Intercambio cultural', 'fecha': '10/03/2026'},
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Sociales',
        icono: Icons.public,
        examenes: [
          {'titulo': 'Examen Geografía', 'fecha': '05/02/2026'},
        ],
        notas: [
          {'titulo': 'Examen Geografía', 'nota': '6.5','fecha': '05/02/2026'},
        ],
        excursiones: [
          {'titulo': 'Visita Parlamento', 'fecha': '20/03/2026'},
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Arte',
        icono: Icons.brush,
        examenes: [
          {'titulo': 'Examen Pintura', 'fecha': '15/02/2026'},
        ],
        notas: [
          {'titulo': 'Examen Pintura', 'nota': '6.8','fecha': '15/02/2026'},
        ],
        excursiones: [
          {'titulo': 'Museo del Prado', 'fecha': '25/03/2026'},
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Educación Física',
        icono: Icons.sports_soccer,
        examenes: [
          {'titulo': 'Prueba resistencia', 'fecha': '25/01/2026'},
        ],
        notas: [
          {'titulo': 'Prueba resistencia', 'nota': '7.2','fecha': '25/01/2026'},
        ],
        excursiones: [
          {'titulo': 'Competición intercolegial', 'fecha': '05/04/2026'},
        ],
      ),
      AsignaturaModelMock(
        nombre: 'Música',
        icono: Icons.music_note,
        examenes: [
          {'titulo': 'Examen Solfeo', 'fecha': '05/02/2026'},
        ],
        notas: [
          {'titulo': 'Examen Solfeo', 'nota': '6.8','fecha': '05/02/2026'},
          {'titulo': 'Examen Canción', 'nota': '8.2','fecha': '22/10/2025'},
        ],
        excursiones: [
          {'titulo': 'Concierto escolar', 'fecha': '15/03/2026'},
        ],
      ),
    ];
  }
}