import 'package:flutter/material.dart';
import '../models/asignatura_model_mock.dart';


class ColegioAsignaturaView extends StatelessWidget {
  final AsignaturaModelMock asignatura;

  const ColegioAsignaturaView({super.key, required this.asignatura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(asignatura.nombre),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(asignatura.icono, size: 28),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Resumen superior
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/iconos/examen.png', width: 32, height: 32),
                    title: const Text('Próximo examen'),
                    subtitle: Text(
                      asignatura.examenes.isNotEmpty
                          ? '${asignatura.examenes.first['titulo']} • ${asignatura.examenes.first['fecha']}'
                          : '—',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/iconos/nota.png', width: 32, height: 32),
                    title: const Text('Última nota'),
                    subtitle: Text(
                      asignatura.notas.isNotEmpty
                          ? '${asignatura.notas.last['titulo']} • ${asignatura.notas.last['nota']}'
                          : '—',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de exámenes
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text('Exámenes'),
                ),
                ...asignatura.examenes.map((ex) => ListTile(
                      title: Text(ex['titulo'] ?? ''),
                      subtitle: Text('Fecha: ${ex['fecha'] ?? '—'}'),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de notas
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.grade),
                  title: Text('Notas'),
                ),
                ...asignatura.notas.map((n) => ListTile(
                      title: Text(n['titulo'] ?? ''),
                      subtitle: Text('Nota: ${n['nota'] ?? '—'}'),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de excursiones
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.hiking),
                  title: Text('Excursiones'),
                ),
                ...asignatura.excursiones.map((e) => ListTile(
                      title: Text(e['titulo'] ?? ''),
                      subtitle: Text('Fecha: ${e['fecha'] ?? '—'}'),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Nueva tarjeta: Tiempo de lectura
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('Tiempo de lectura'),
                  subtitle: Text('—'), // aquí luego podrás poner el temporizador real
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}