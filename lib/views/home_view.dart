import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/controllers/home_assistant_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/views/aula_view.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/colegio_view.dart';
import 'package:conectask_v2/views/configuracion_view.dart';
import 'package:conectask_v2/views/home_assistant_view.dart';
import 'package:conectask_v2/views/login_view.dart';
import 'package:conectask_v2/views/menu_semanal_view.dart';
import 'package:conectask_v2/controllers/menu_semanal_controller.dart';
import 'package:conectask_v2/views/recompensas_view.dart';
import 'package:conectask_v2/views/task_view.dart';
import 'package:conectask_v2/widgets/receta_modulo.dart';
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

  void cargarDatosIniciales() async {
    final usuarioController = Provider.of<UsuarioController>(
      context,
      listen: false,
    );
    await usuarioController.cargarUsuarios();
    print('✅ Usuarios cargados: ${usuarioController.usuarios.length}');
  }

  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;
    final uid = firebaseUser?.uid;

    cargarDatosIniciales();

    if (uid != null && uid == widget.user.id) {
      print('✅ UID coincide. Puedes acceder a Firebase.');
    } else {
      print('❌ UID no coincide o usuario no autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);

    // Obtenemos los módulos visibles según el rol
    final modulos = usuarioController.obtenerModulosPorRol(widget.user.rol);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${widget.user.nombre}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Cerrar sesión?'),
                  content: Text(
                    '¿Quieres cerrar sesión, ${widget.user.nombre}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
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
            secondary: SizedBox(
              width: 80,
              height: 80,
              child: RecetaModulo(
                assetPath: 'assets/animaciones/camara.json',
                factor: 1,
              ),
            ),
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
                      onTap: () async {
                        switch (modulo['titulo']) {
                          case 'Recompensas':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecompensasView(user: widget.user),
                              ),
                            );
                            break;
                          case 'Configuración':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConfiguracionView(user: widget.user),
                              ),
                            );
                            break;
                          case 'Menú semanal':
                            final controller = MenuSemanalController();
                            final datos = await controller.leerMenu();
                            final Map<String, dynamic> menuMap = {
                              for (var dia in datos) dia.fecha: dia.toMap(),
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
                            break;
                          case 'Tareas':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TasksView(user: widget.user),
                              ),
                            );
                            break;
                          case 'Colegio':
                            if (widget.user.rol == 'niño') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AulaView(user: widget.user),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => ColegioController(),
                                    child: ColegioView(user: widget.user),
                                  ),
                                ),
                              );
                            }
                            break;
                          case 'Casa':
                            final homeController =
                                Provider.of<HomeAssistantController>(
                                  context,
                                  listen: false,
                                );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeAssistantView(
                                  controller: homeController,
                                  rolUsuario: widget.user.rol,
                                ),
                              ),
                            );
                            break;
                          case 'Calendario':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CalendarView(
                                  fechaInicial: DateTime.now(),
                                  user: widget.user,
                                ),
                              ),
                            );
                            break;
                          default:
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
                          Expanded(
                            child: Center(child: modulo['icono'] as Widget),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            modulo['titulo'],
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
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
