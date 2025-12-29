import 'package:conectask_v2/views/register_view.dart';
import 'package:conectask_v2/common/widgets/animacion_brillo_texto.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import '../common/constants/constant.dart';
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
          builder: (_) => HomeView(user: user), // Paso el usuario
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppMessagesConstants.msgErrorMailContrasenia),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                    AppIconsConstants.loginConnection,
                    fit: BoxFit.contain,
                    repeat: true, // se repite indefinidamente
                  ),
                ),
                const SizedBox(height: 20),

                // 🔑 Tu texto con animación de brillo debajo
                AnimacionBrilloTexto(
                  text: AppThemeConstants.titulo,
                  style: TextStyle(
                    fontFamily: AppThemeConstants.letraTitulo,
                    //color: ,
                    fontSize: min(height * 0.10, 60),
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  duration: const Duration(seconds: 3),
                  shineColor: const Color.fromARGB(255, 10, 206, 196),
                ),

                const SizedBox(height: 20),
                Text(
                  _modoNino
                      ? AppFieldsConstants.accesoNinos
                      : AppFieldsConstants.inicioSesion,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                if (_modoNino) ...[
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      labelText: AppFieldsConstants.labelusuario,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: AppFieldsConstants.labelPin,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final usuario = _usuarioController.text.trim();
                      final pin = _pinController.text.trim();

                      print('Buscando usuario con nombre: $usuario'); // Paso 2

                      if (usuario.isEmpty || pin.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              AppMessagesConstants.msgCompletaUsuarioPin,
                            ),
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

                      if (user != null && user.rol == AppConstants.rolNino) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeView(user: user),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              AppMessagesConstants.msgErrorUsuarioPin,
                            ),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(AppFieldsConstants.entrar),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => setState(() => _modoNino = false),
                    icon: Image.asset(
                      AppIconsConstants.flechaVolver,
                      width: 40,
                      height: 40,
                    ),
                    label: const Text(AppFieldsConstants.labelVolverAdulto),
                  ),
                ] else ...[
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: AppFieldsConstants.labelEmail,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: AppFieldsConstants.labelContrasenia,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(AppFieldsConstants.entrar),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    ),
                    child: const Text(AppFieldsConstants.sinCuenta),
                  ),
                  const SizedBox(height: 16),
                  // 🔑 Botón de acceso para niños (modificado)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(240, 60), // botón más compacto
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    onPressed: () => setState(() => _modoNino = true),
                    icon: Image.asset(
                      AppIconsConstants.monstruo,
                      width: 60,
                      height: 60,
                    ),
                    label: const Text(
                      AppFieldsConstants.lableAccesoNinos,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
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
