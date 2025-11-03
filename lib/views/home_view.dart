import 'package:flutter/material.dart';
import '../models/user_model.dart';

class HomeView extends StatefulWidget {
  final UserModel user; // Usuario recibido desde login o registro

  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool mostrarFotos = false; // Estado del interruptor

  final List<Map<String, dynamic>> modulos = [
    {'titulo': 'Tareas', 'icono': Icons.cleaning_services},
    {'titulo': 'Menú semanal', 'icono': Icons.restaurant_menu},
    {'titulo': 'Modo estudio', 'icono': Icons.school},
    {'titulo': 'Casa', 'icono': Icons.home},
    {'titulo': 'Recompensas', 'icono': Icons.emoji_events},
    {'titulo': 'Calendario', 'icono': Icons.calendar_today},
    {'titulo': 'Configuración', 'icono': Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido, ${widget.user.nombre}',
        ), // Muestra el nombre del usuario
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Modo Fotos'),
            value: mostrarFotos,
            onChanged: (bool valor) {
              setState(() {
                mostrarFotos = valor;
              });
            },
            secondary: const Icon(Icons.photo),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: modulos.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final modulo = modulos[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Aquí puedes poner la navegación a cada módulo
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(modulo['icono'], size: 32),
                          const SizedBox(height: 8),
                          Text(
                            modulo['titulo'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
