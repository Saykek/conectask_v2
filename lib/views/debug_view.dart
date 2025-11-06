import 'package:conectask_v2/models/user_model.dart';
import 'package:conectask_v2/services/user_service.dart';
import 'package:flutter/material.dart';

class DebugView extends StatelessWidget {
  const DebugView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final nino = UserModel(
              id: 'uid_nino_demo',
              nombre: 'Erik',
              rol: 'niño',
              pin: '1234',
              nivel: 1,
              puntos: 0,
            );

            await UserService().guardarUsuario(nino);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Niño creado correctamente')),
            );
          },
          child: const Text('Crear niño de prueba'),
        ),
      ),
    );
  }
}
