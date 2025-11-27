import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/widgets/temporizador_lectura.dart';
import 'package:flutter/material.dart';

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
            image: AssetImage('assets/images/fondo_aula.png'),
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
        _buildBoton(context, Icons.calendar_today, 'Pizarra', () {
          // abrir calendario
        }),
        const SizedBox(height: 16),
        _buildBoton(context, Icons.timer, 'Temporizador', () {
          // abrir temporizador
        }),
        const SizedBox(height: 16),
        _buildBoton(context, Icons.star, 'Recompensas', () {
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
        _buildBoton(context, Icons.calendar_today, 'Pizarra', () {
          // abrir calendario
        }),
        _buildBoton(context, Icons.timer, 'Temporizador', () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TemporizadorLectura(),
    ),
  );
}),
        _buildBoton(context, Icons.star, 'Recompensas', () {
          // abrir recompensas
        }),
        _buildBoton(context, Icons.task, 'Tareas', () {
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
