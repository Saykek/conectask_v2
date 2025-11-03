import 'package:conectask_v2/views/add_task_view.dart';
import 'package:flutter/material.dart';

class TasksView extends StatelessWidget {
  // Lista de usuarios con su color
  final List<Map<String, dynamic>> usuarios = [
    {'nombre': 'Mamá', 'color': Colors.pink[200]},
    {'nombre': 'Papá', 'color': Colors.blue[200]},
    {'nombre': 'Álex', 'color': const Color.fromARGB(255, 72, 45, 135)},
    {'nombre': 'Erik', 'color': const Color.fromARGB(255, 66, 177, 77)},
  ];

  TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas Familiares"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Añdir nueva Tarea',
            onPressed: () {
              // Acción para agregar una nueva tarea
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis
            .horizontal, // Para permitir scroll horizontal si hay muchos usuarios
        child: Row(
          children: List.generate(usuarios.length, (index) {
            final usuario = usuarios[index]; // Esto es un Map
            final color =
                usuario['color'] ??
                Colors.grey; // Tomamos el color del map o gris por defecto

            return Container(
              width: 150, // Ancho de cada columna
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2), // Fondo suave del color
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color), // Borde del mismo color
              ),
              child: Column(
                children: [
                  // Mostramos el nombre del usuario
                  Text(
                    usuario['nombre'], // Accedemos al valor 'nombre' del Map
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Aquí pondremos las tareas
                  const Text('Tareas...'),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
