import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/widgets/navegacion.dart';
import 'package:conectask_v2/models/examen_model.dart';
import 'package:conectask_v2/widgets/temporizador_estudio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ColegioView extends StatelessWidget {
  final UserModel user;

  const ColegioView({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ColegioController>(context);
    final formato = DateFormat('yyyy-MM-dd');
    final esAdmin = user.rol == 'admin';

    final examenesHoy = controller.examenes.where((e) =>
      formato.format(e.fecha) == formato.format(controller.fechaSeleccionada)
    ).toList();

    final esAdulto = user.rol == 'admin' || user.rol == 'adulto';
    final usuarios = esAdulto
    ? controller.usuariosLocales
    : [user];

    return Scaffold(
      appBar: AppBar(title: const Text('Vista Colegio')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: NavegacionFecha(
              fechaActual: controller.fechaSeleccionada,
              onFechaCambiada: controller.setFechaSeleccionada,
            ),
          ),
          Expanded(
            child: esAdulto
                ? ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      final examenesUsuario = examenesHoy
                          .where((e) => e.responsable == usuario.id)
                          .toList();

                      return _buildTarjetaUsuario(usuario, examenesUsuario, context);
                    },
                  )
                : _buildTarjetaUsuario(
                    user,
                    examenesHoy.where((e) => e.responsable == user.id).toList(),
                    context,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaUsuario(UserModel usuario, List<Examen> examenes, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(usuario.nombre),
        subtitle: Text('${examenes.length} examen${examenes.length == 1 ? '' : 'es'}'),
        children: examenes.map((examen) {
          return ListTile(
            title: Text(examen.titulo),
            subtitle: Text(examen.descripcion),
            trailing: IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TemporizadorEstudio(examen: examen),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}