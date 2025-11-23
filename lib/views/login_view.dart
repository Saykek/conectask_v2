import 'package:conectask_v2/views/register_view.dart';
import 'package:conectask_v2/widgets/animacion_brillo_texto.dart';
import 'package:conectask_v2/widgets/receta_modulo.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../controllers/login_controller.dart';
import 'home_view.dart';
import '../models/user_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  bool _modoNino = false; // Para alternar entre modo admin y niño
  final _usuarioController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usuarioController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);

    final UserModel? user = await _controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeView(user: user), // Pasamos el usuario
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔑 Animación Lottie arriba
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    'assets/animaciones/connecting.json',
                    fit: BoxFit.contain,
                    repeat: true, // se repite indefinidamente
                  ),
                ),
                const SizedBox(height: 32),

                // 🔑 Tu texto con animación de brillo debajo
                AnimacionBrilloTexto(
                  text: "Conectask",
                  style: const TextStyle(
                    fontFamily: 'Hillgates',
                    //color: ,
                    fontSize: 100,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  duration: const Duration(seconds: 3),
                  shineColor: const Color.fromARGB(
                    255,
                    9,
                    99,
                    84,
                  ), // color del brillo
                ),

                const SizedBox(height: 32),
                Text(
                  _modoNino ? 'Acceso para niños' : 'Iniciar sesión',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                if (_modoNino) ...[
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'PIN'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final usuario = _usuarioController.text.trim();
                      final pin = _pinController.text.trim();

                      print('Buscando usuario con nombre: $usuario'); // Paso 2

                      if (usuario.isEmpty || pin.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, completa usuario y PIN'),
                          ),
                        );
                        return;
                      }

                      final user = await _controller.loginNino(
                        usuario: usuario,
                        pin: pin,
                      );

                      print(
                        'Resultado: ${user?.nombre}, PIN: ${user?.pin}, Rol: ${user?.rol}',
                      ); //  Verificación

                      if (!mounted) return;

                      if (user != null && user.rol == 'niño') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeView(user: user),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario o PIN incorrecto'),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _modoNino = false),
                    child: const Text('🔙 Volver al login de admin'),
                  ),
                ] else ...[
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text('Entrar'),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    ),
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => setState(() => _modoNino = true),
                    icon: SizedBox(
                      width: 70,
                      height: 70,
                      child: RecetaModulo(
                        assetPath: 'assets/animaciones/katapum.json',
                        factor: 1.0, // ocupa todo el SizedBox
                      ),
                    ),
                    label: const Text('Acceso para niños'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
