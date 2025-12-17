import 'package:conectask_v2/controllers/recompensa_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';

import '../common/constants/constant.dart';

class RecompensasHistorialCanjeosView extends StatefulWidget {
  final UserModel user;
  final RecompensaController controller = RecompensaController();

  RecompensasHistorialCanjeosView({super.key, required this.user});

  @override
  State<RecompensasHistorialCanjeosView> createState() =>
      _RecompensasHistorialCanjeosViewState();
}

class _RecompensasHistorialCanjeosViewState
    extends State<RecompensasHistorialCanjeosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial de ${widget.user.nombre}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.controller.obtenerCanjeos(widget.user.nombre),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final canjeos = snapshot.data!;
          if (canjeos.isEmpty) {
            return const Center(child: Text(AppMessagesConstants.msgSinCanjeos));
          }
          return ListView.builder(
            itemCount: canjeos.length,
            itemBuilder: (context, i) {
              final c = canjeos[i];
              final entregado = c['entregado'] ?? false;

              return ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: Text(c['recompensaNombre']),
                subtitle: Text(
                  'Usuario: ${c['usuarioNombre']} • Coste: ${c['coste']} pts',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      c['fecha'].toString().substring(0, 10),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Checkbox(
                      value: entregado,
                      onChanged: (val) async {
                        final key = c['key']; //  key del nodo en Firebase
                        await widget.controller.marcarEntregado(
                            key, val ?? false);
                        setState(() {
                          c['entregado'] = val ?? false;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}