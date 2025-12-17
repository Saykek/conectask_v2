import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/common/widgets/temporizador_lectura.dart';
import 'package:flutter/material.dart';
import '../common/constants/constant.dart';

class AulaView extends StatelessWidget {
  final UserModel user;

  const AulaView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: Text('Aula de ${user.nombre}')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIconsConstants.fondo_aula),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildWebLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBoton(context, Icons.calendar_today, AppFieldsConstants.pizarra, () {
          // abrir calendario
        }),
        const SizedBox(height: 16),
        _buildBoton(context, Icons.timer, AppFieldsConstants.temporizador, () {
          // abrir temporizador
        }),
        const SizedBox(height: 16),
        _buildBoton(context, Icons.star, AppFieldsConstants.recompensas, () {
          // abrir recompensas
        }),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: [
        _buildBoton(context, Icons.calendar_today, AppFieldsConstants.pizarra, () {
          // abrir calendario
        }),
        _buildBoton(context, Icons.timer, AppFieldsConstants.temporizador, () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TemporizadorLectura(),
    ),
  );
}),
        _buildBoton(context, Icons.star, AppFieldsConstants.recompensas, () {
          // abrir recompensas
        }),
        _buildBoton(context, Icons.task, AppFieldsConstants.tareas, () {
          // abrir tareas
        }),
      ],
    );
  }

  Widget _buildBoton(
    BuildContext context,
    IconData icono,
    String texto,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.orangeAccent,
            child: Icon(icono, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
