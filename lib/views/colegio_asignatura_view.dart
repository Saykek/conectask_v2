import 'package:flutter/material.dart';

class ColegioAsignaturaView extends StatelessWidget {
  final String nombreAsignatura;
  final IconData icono;

  const ColegioAsignaturaView({
    super.key,
    required this.nombreAsignatura,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreAsignatura),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Icono grande de la asignatura
          Center(
            child: Column(
              children: [
                Icon(icono, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 12),
                Text(
                  nombreAsignatura,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bloque de Exámenes
          Card(
            child: ListTile(
              leading: Image.asset('assets/iconos/examen.png', width: 32, height: 32),
              title: const Text('Próximos exámenes'),
              subtitle: const Text('Aquí se listarán los exámenes con fecha'),
            ),
          ),
          const SizedBox(height: 16),

          // Bloque de Notas
          Card(
            child: ListTile(
              leading: Image.asset('assets/iconos/nota.png', width: 32, height: 32),
              title: const Text('Notas de los exámenes'),
              subtitle: const Text('Aquí se mostrarán las notas registradas'),
            ),
          ),
          const SizedBox(height: 16),

          // Bloque de Gráficas
          Card(
            child: ListTile(
              leading: Image.asset('assets/iconos/media_notas.png', width: 32, height: 32),
              title: const Text('Gráficas de medias'),
              subtitle: const Text('Placeholder para gráficas de rendimiento'),
            ),
          ),
          const SizedBox(height: 16),

          // Bloque de Excursiones
          Card(
            child: ListTile(
              leading: const Icon(Icons.hiking, size: 32, color: Colors.green),
              title: const Text('Excursiones'),
              subtitle: const Text('Aquí se mostrarán excursiones con fecha'),
            ),
          ),
          const SizedBox(height: 16),

          // Bloque de Tiempo de estudio
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer, size: 32, color: Colors.deepOrange),
              title: const Text('Tiempo de estudio'),
              subtitle: const Text('Placeholder para registrar tiempo de estudio'),
            ),
          ),
        ],
      ),
    );
  }
}