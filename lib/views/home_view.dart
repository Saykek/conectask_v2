import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/controllers/home_assistant_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/home_assistant_model.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/home_assistant_service.dart';
import 'package:conectask_v2/views/aula_view.dart';
import 'package:conectask_v2/views/calendar_view.dart';
import 'package:conectask_v2/views/colegio_view.dart';
import 'package:conectask_v2/views/configuracion_view.dart';
import 'package:conectask_v2/views/home_assistant_view.dart';
import 'package:conectask_v2/views/login_view.dart';
import 'package:conectask_v2/views/menu_semanal_view.dart';
import 'package:conectask_v2/controllers/menu_semanal_controller.dart';
import 'package:conectask_v2/views/prueba_imagen_view.dart';
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

  final List<Map<String, dynamic>> modulos = [
    {
      'titulo': 'Tareas',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/tarea.json',
        factor: 1,
      ),
    },
    {
      'titulo': 'Menú semanal',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/receta_ani.json',
        factor: 1,
      ),
    },
    {
      'titulo': 'Colegio',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/colegio.json',
        factor: 1,
      ),
    },
    {
      'titulo': 'Casa',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/home_conection.json',
        factor: 1.2,
      ),
    },
    {
      'titulo': 'Recompensas',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/regalo.json',
        factor: 1,
      ),
    },
    {
      'titulo': 'Calendario',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/calendario.json',
        factor: 1,
      ),
    },
    {
      'titulo': 'Configuración',
      'icono': RecetaModulo(
        assetPath: 'assets/animaciones/configuracion.json',
        factor: 1,
      ),
    },
  ];

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

    //print('UID autenticado por Firebase: $uid');
    //print('ID del modelo recibido: ${widget.user.id}');

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
                      // Navegación a cada módulo
                      onTap: () async {
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PruebaImagenView(),
                              ),
                            );
                          },
                          child: const Text('Ver imagen de fondo'),
                        );
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
                        } else if (modulo['titulo'] == 'Tareas') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TasksView(user: widget.user),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Colegio') {
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
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) => ColegioController(),
                                  child: ColegioView(user: widget.user),
                                ),
                              ),
                            );
                          }
                        } else if (modulo['titulo'] == 'Casa') {
                          // 1. Crear el modelo con tu URL y token
                          final homeModel = HomeAssistantModel(
                            baseUrl:
                                "https://demo.home-assistant.io", // tu instancia HA
                            accessToken: "TOKEN_DEMO", // tu long-lived token
                            panel: "default", // panel lovelace
                            soloAdmin: true, // solo admin puede acceder
                          );

                          // 2. Crear el servicio
                          final homeService = HomeAssistantService(homeModel);

                          // 3. Crear el controlador
                          final homeController = HomeAssistantController(
                            homeService,
                          );

                          // 4. Navegar a la vista pasando el controlador y el rol del usuario
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeAssistantView(
                                controller: homeController,
                                rolUsuario: widget.user.rol, //"admin" o "niño"
                              ),
                            ),
                          );
                        } else if (modulo['titulo'] == 'Calendario') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarView(
                                fechaInicial: DateTime.now(),
                                user: widget.user,
                              ),
                            ),
                          );
                        } else {
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
                          Expanded(
                            // 🔑 esto da espacio vertical a la animación
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
