import 'package:conectask_v2/views/crear_nino_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  List<UserModel> _ninos = [];

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _controller.cargarConfiguracion(uid).then((_) {
        setState(() {
          cargando = false;
          _urlController.text = _controller.configuracion.urlServidor;
        });
      });

      _controller.cargarNinos().then((ninos) {
        setState(() {
          _ninos = ninos;
        });
      });
    } else {
      print('Usuario no autenticado');
    }
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
          const Text('⚙️ General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Tema'),
            trailing: DropdownButton<String>(
              value: config.tema,
              items: ['claro', 'oscuro']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
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
              items: ['es', 'en']
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
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
              items: ['admin', 'niño']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) {
                setState(() => _controller.actualizarCampo('rol', value));
                _controller.guardarConfiguracion(widget.user.id);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('🔔 Notificaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Activar notificaciones'),
            value: config.notificacionesActivas,
            onChanged: (value) {
              setState(() => _controller.actualizarCampo('notificacionesActivas', value));
              _controller.guardarConfiguracion(widget.user.id);
            },
          ),
          const SizedBox(height: 16),
          const Text('🌐 Conexión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            decoration: const InputDecoration(labelText: 'URL del servidor'),
            controller: _urlController,
            onChanged: (value) {
              _controller.actualizarCampo('urlServidor', value);
              _controller.guardarConfiguracion(widget.user.id);
            },
          ),
          const SizedBox(height: 16),
          const Text('👤 Gestión de usuarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         ElevatedButton.icon(
  icon: const Icon(Icons.person_add),
  label: const Text('Crear niño'),
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CrearNinoView()),
    );
    final nuevos = await _controller.cargarNinos();
    setState(() {
      _ninos = nuevos;
    });
  },
),
          const SizedBox(height: 16),
          const Text('👶 Perfiles de niños', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ..._ninos.map((nino) => Card(
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(nino.nombre),
              subtitle: Text('Nivel ${nino.nivel ?? 1} • Puntos ${nino.puntos ?? 0}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CrearNinoView(nino: nino),
    ),
  );
  // Recargar la lista de niños después de volver
  final nuevos = await _controller.cargarNinos();
  setState(() {
    _ninos = nuevos;
  });
},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final ref = FirebaseDatabase.instance.ref('usuarios/${nino.id}');
                      await ref.remove();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Niño ${nino.nombre} eliminado')),
                      );
                      setState(() {
                        _ninos.removeWhere((u) => u.id == nino.id);
                      });
                    },
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}