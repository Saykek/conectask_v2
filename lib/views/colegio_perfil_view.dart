import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/utils/colegio_utils.dart'; // 👈 lógica escolar global
import 'package:conectask_v2/widgets/tarjeta_asignatura.dart';
import 'package:flutter/material.dart';
import '../services/asignatura_service_mock.dart';
import 'colegio_asignatura_view.dart';



class ColegioPerfilView extends StatelessWidget {
  final UserModel usuario;

  const ColegioPerfilView({required this.usuario, super.key});

  @override
  Widget build(BuildContext context) {
    final asignaturas = AsignaturaServiceMock.obtenerAsignaturas();

    final screenWidth = MediaQuery.of(context).size.width;
    final esMovil = screenWidth < 600;

    // Número de columnas según ancho
    final crossAxisCount = esMovil
        ? 1
        : screenWidth < 1200
            ? 2
            : 3;

    // Altura base de la tarjeta
    final alturaBase = 260.0;

    // Proporción del grid dinámicamente
    final childAspectRatio =
        (screenWidth / crossAxisCount) / alturaBase;

    return Scaffold(
      appBar: AppBar(title: Text('Perfil escolar de ${usuario.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: asignaturas.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final asignatura = asignaturas[index];

            final proximoExamen =
                ColegioUtils.proximoExamen(asignatura.examenes);
            final ultimaNota = ColegioUtils.ultimaNota(asignatura.notas);
            final mediaNotas = ColegioUtils.mediaNotas(asignatura.notas);

            return TarjetaAsignatura(
              nombre: asignatura.nombre,
              icono: asignatura.icono,
              proximoExamen: proximoExamen,
              ultimaNota: ultimaNota,
              mediaNotas: mediaNotas,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ColegioAsignaturaView(asignatura: asignatura),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
