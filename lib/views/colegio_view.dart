import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/colegio_perfil_view.dart';
import 'package:conectask_v2/widgets/tarjeta_alumno.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/asignatura_service_mock.dart';
import 'package:conectask_v2/utils/colegio_utils.dart';

class ColegioView extends StatelessWidget {
  final UserModel user;

  const ColegioView({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    final esAdulto = user.rol == 'admin' || user.rol == 'adulto';

    final usuarios = esAdulto
        ? usuarioController.usuarios.where((u) => u.rol == 'niño').toList()
        : [user];

    return Scaffold(
      appBar: AppBar(title: const Text('Colegio')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: usuarios.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // columnas
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final usuario = usuarios[index];

            // ✅ obtenemos asignaturas del usuario (mock)
            final asignaturas = AsignaturaServiceMock.obtenerAsignaturas();

            // ✅ cálculos globales del alumno
            final proximoExamenGlobal = ColegioUtils.proximoExamen(
              asignaturas.expand((a) => a.examenes).toList(),
            );
            final ultimaNotaGlobal = ColegioUtils.ultimaNota(
              asignaturas.expand((a) => a.notas).toList(),
            );
            final mediaNotasGlobal = ColegioUtils.mediaNotas(
              asignaturas.expand((a) => a.notas).toList(),
            );

            return TarjetaAlumno(
              usuario: usuario,
              proximoExamen: proximoExamenGlobal,
              ultimaNota: ultimaNotaGlobal,
              mediaNotas: mediaNotasGlobal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ColegioPerfilView(usuario: usuario),
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
