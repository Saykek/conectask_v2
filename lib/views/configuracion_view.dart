import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/configuracion_controller.dart';
import '../models/user_model.dart'; // si usas uid desde aquí

class ConfiguracionView extends StatefulWidget {
  final UserModel user;

  const ConfiguracionView({super.key, required this.user});

  @override
  State<ConfiguracionView> createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  final ConfiguracionController _controller = ConfiguracionController();
  bool cargando = true;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _controller.cargarConfiguracion(uid).then((_) {
        setState(() {
          cargando = false;
        });
      });
    } else {
      print('Usuario no autenticado');
      // Aquí podrías redirigir al login o mostrar un error
    }

    print('UID autenticado: ${FirebaseAuth.instance.currentUser?.uid}');
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final config = _controller.configuracion;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '⚙️ General',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Tema'),
            trailing: DropdownButton<String>(
              value: config.tema,
              items: [
                'claro',
                'oscuro',
              ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (value) {
                setState(() => _controller.actualizarCampo('tema', value));
                _controller.guardarConfiguracion(widget.user.id);
              },
            ),
          ),
          ListTile(
            title: const Text('Idioma'),
            trailing: DropdownButton<String>(
              value: config.idioma,
              items: [
                'es',
                'en',
              ].map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (value) {
                setState(() => _controller.actualizarCampo('idioma', value));
                _controller.guardarConfiguracion(widget.user.id);
              },
            ),
          ),
          ListTile(
            title: const Text('Rol'),
            trailing: DropdownButton<String>(
              value: config.rol,
              items: [
                'admin',
                'niño',
              ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (value) {
                setState(() => _controller.actualizarCampo('rol', value));
                _controller.guardarConfiguracion(widget.user.id);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '🔔 Notificaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('Activar notificaciones'),
            value: config.notificacionesActivas,
            onChanged: (value) {
              setState(
                () =>
                    _controller.actualizarCampo('notificacionesActivas', value),
              );
              _controller.guardarConfiguracion(widget.user.id);
            },
          ),
          const SizedBox(height: 16),
          const Text(
            '🌐 Conexión',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'URL del servidor'),
            controller: TextEditingController(text: config.urlServidor),
            onChanged: (value) {
              _controller.actualizarCampo('urlServidor', value);
              _controller.guardarConfiguracion(widget.user.id);
            },
          ),
        ],
      ),
    );
  }
}
