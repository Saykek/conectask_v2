import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/widgets/tarjeta_asignatura.dart';
import 'package:flutter/material.dart';

class ColegioPerfilView extends StatelessWidget {
  final UserModel usuario;

  const ColegioPerfilView({required this.usuario, super.key});

  @override
  Widget build(BuildContext context) {
    final asignaturas = [
      'Matemáticas',
      'Lengua',
      'Ciencias',
      'Inglés',
      'Sociales',
      'Arte',
      'Educación Física',
      'Música',
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Perfil escolar de ${usuario.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: asignaturas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final asignatura = asignaturas[index];
            return TarjetaAsignatura(
              nombre: asignatura,
              icono: _iconoPorAsignatura(asignatura),
              proximoExamen: '—',
              mediaNotas: '—',
              ultimaNota: '—',
              onTap: () {
                // Aquí puedes navegar al detalle de la asignatura si lo deseas
              },
            );
          },
        ),
      ),
    );
  }

  IconData _iconoPorAsignatura(String asignatura) {
    switch (asignatura.toLowerCase()) {
      case 'matemáticas':
        return Icons.calculate;
      case 'lengua':
        return Icons.menu_book;
      case 'ciencias':
      case 'naturales':
        return Icons.eco;
      case 'inglés':
        return Icons.language;
      case 'sociales':
        return Icons.public;
      case 'arte':
        return Icons.brush;
      case 'educación física':
        return Icons.sports_soccer;
      case 'música':
        return Icons.music_note;
      default:
        return Icons.school;
    }
  }
}
