import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/theme/colegio_theme.dart';
import 'package:conectask_v2/views/colegio_perfil_view.dart';
import 'package:conectask_v2/widgets/navegacion.dart';
import 'package:conectask_v2/widgets/tarjeta_alumno.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Theme(
      data: ColegioTheme.light,
      child: Scaffold(
        appBar: AppBar(title: const Text('Vista Colegio')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: usuarios.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos tarjetas por fila
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1, // Cuadradas
            ),
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return TarjetaAlumno(
                usuario: usuario,
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
      ),
    );
  }
}
