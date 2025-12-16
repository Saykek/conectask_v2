import 'package:conectask_v2/common/constants/constant.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final LoginController _controller = LoginController();

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppMessagesConstants.msgCompletaCampos)),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Ahora register devuelve bool
      final bool success = await _controller.register(
        nombre: nombre,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        // Crear el UserModel con el UID obtenido de Firebase
        final user = UserModel(
          id: _controller.auth.currentUser!.uid,
          nombre: nombre,
          email: email,
          rol: AppConstants.rolAdmin,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeView(user: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppMessagesConstants.msgErrorMail),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppMessagesConstants.msgErrorRegistro}${e.toString()}'),
));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppFieldsConstants.registroUsuario)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: AppFieldsConstants.labelNombre),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: AppFieldsConstants.mail),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: AppFieldsConstants.contrasenia,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AppFieldsConstants.registrar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
