import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/colegio_view.dart';
import 'package:conectask_v2/views/configuracion_view.dart';
import 'package:conectask_v2/views/debug_view.dart';
import 'package:conectask_v2/views/menu_semanal_view.dart';
import 'package:conectask_v2/controllers/menu_semanal_controller.dart';
import 'package:conectask_v2/views/recompensas_view.dart';
import 'package:conectask_v2/views/task_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
    {'titulo': 'Colegio', 'icono': Icons.school},
    {'titulo': 'Casa', 'icono': Icons.home},
    {'titulo': 'Recompensas', 'icono': Icons.emoji_events},
    {'titulo': 'Calendario', 'icono': Icons.calendar_today},
    {'titulo': 'Configuración', 'icono': Icons.settings},
  ];

  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;
    final uid = firebaseUser?.uid;

    print('UID autenticado por Firebase: $uid');
    print('ID del modelo recibido: ${widget.user.id}');

    if (uid != null && uid == widget.user.id) {
      print('✅ UID coincide. Puedes acceder a Firebase.');
      // Aquí podrías cargar configuración si lo deseas
      // Por ejemplo:
      // final configuracionController = ConfiguracionController();
      // configuracionController.cargarConfiguracion(uid);
    } else {
      print('❌ UID no coincide o usuario no autenticado.');
      // Puedes redirigir al login o mostrar un error
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Rol del usuario: ${widget.user.rol}');
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
          if (widget.user.rol == 'admin') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DebugView()),
                  );
                },
                icon: const Icon(Icons.bug_report),
                label: const Text('Debug: Crear niño de prueba'),
              ),
            ),
            const SizedBox(height: 16),
          ],
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
                      // Navegación a cada módulo
                      onTap: () async {
                        if (modulo['titulo'] == 'Recompensas') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecompensasView(user: widget.user),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Configuración') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConfiguracionView(user: widget.user),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Menú semanal') {
                          final controller = MenuSemanalController();
                          final menuList = await controller.cargarMenu();

                          final Map<String, Map<String, dynamic>> menuMap = {
                            for (var dia in menuList) dia.dia: dia.toMap(),
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuSemanalView(
                                menu: menuMap,
                                user: widget.user,
                              ),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Tareas') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TasksView(user: widget.user),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Colegio') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ColegioController(),
        child: ColegioView(user: widget.user),
      ),
    ),
  );
}

                        
                        else if (modulo['titulo'] == 'Calendario') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CalendarView(
        fechaInicial: DateTime.now(),
        user: widget.user,
      ),
    ),
  );
}
                        else {
                          // Para otros módulos, mostrar un SnackBar temporalmente
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Módulo "${modulo['titulo']}" en desarrollo.',
                              ),
                            ),
                          );
                        }
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
