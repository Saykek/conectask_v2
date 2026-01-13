import 'package:conectask_v2/controllers/recompensa_controller.dart';
import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';

import '../common/constants/constant.dart';

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../controllers/recompensa_controller.dart';
import '../common/constants/app_messages_constants.dart';
import '../common/constants/app_constants.dart';

class RecompensasHistorialCanjeosView extends StatefulWidget {
  final UserModel usuarioLogueado; // quien usa la app
  final UserModel usuarioHistorial; // de quien se muestra el historial

  final RecompensaController controller = RecompensaController();

  RecompensasHistorialCanjeosView({
    super.key,
    required this.usuarioLogueado,
    required this.usuarioHistorial,
  });

  @override
  State<RecompensasHistorialCanjeosView> createState() =>
      _RecompensasHistorialCanjeosViewState();
}

class _RecompensasHistorialCanjeosViewState
    extends State<RecompensasHistorialCanjeosView> {
  bool get puedeMarcar {
    final rol = widget.usuarioLogueado.rol;
    return rol == AppConstants.rolAdmin ||
        rol == AppConstants.rolPadre ||
        rol == AppConstants.rolAdulto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de ${widget.usuarioHistorial.nombre}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.controller.obtenerCanjeos(
          widget.usuarioHistorial.nombre,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final canjeos = snapshot.data!;

          if (canjeos.isEmpty) {
            return const Center(
              child: Text(AppMessagesConstants.msgSinCanjeos),
            );
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
                      onChanged: puedeMarcar
                          ? (val) async {
                              final key = c['key'];
                              await widget.controller.marcarEntregado(
                                key,
                                val ?? false,
                              );
                              setState(() {
                                c['entregado'] = val ?? false;
                              });
                            }
                          : null,
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
