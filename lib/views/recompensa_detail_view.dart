import 'package:conectask_v2/controllers/recompensa_controller.dart';
import 'package:conectask_v2/views/recompensa_add_view.dart';
import 'package:flutter/material.dart';
import '../common/constants/constant.dart';
import '../models/recompensa_model.dart';
import '../models/user_model.dart';

class RecompensaDetailView extends StatefulWidget {
  final RecompensaModel recompensa;
  final UserModel user;

  const RecompensaDetailView({
    super.key,
    required this.recompensa,
    required this.user,
  });

  @override
  State<RecompensaDetailView> createState() => _RecompensaDetailViewState();
}

class _RecompensaDetailViewState extends State<RecompensaDetailView> {
  final RecompensaController _controller = RecompensaController();
  late RecompensaModel recompensa;

  @override
  void initState() {
    super.initState();
    recompensa = widget.recompensa;
  }

  void _editarRecompensa() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecompensaAddView(recompensa: recompensa),
      ),
    );

    if (resultado is RecompensaModel) {
      setState(() {
        recompensa = resultado;
      });
    }
  }

  Future<void> _eliminarRecompensa(BuildContext context, String id) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(AppFieldsConstants.eliminarRecompensa),
      content: const Text(AppMessagesConstants.msgConfirmarEliminar),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text(AppFieldsConstants.cancelar),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(AppFieldsConstants.eliminar),
        ),
      ],
    ),
  );

  if (confirm == true) {
    final controller = RecompensaController();
    await controller.eliminarRecompensa(id);
    Navigator.pop(context, true); // avisar al padre para refrescar
  }
}

  /// Canjea una recompensa: resta puntos activos y registra el canjeo
  Future<void> _canjearRecompensa() async {
    try {
      //  Llamada al controller, que orquesta la lógica con los services
      await _controller.canjear(widget.user, recompensa);

      //  Forzamos actualización inmediata en memoria
      setState(() {
        recompensa = recompensa.copyWith(usada: true);
      });

      if (mounted) {
        print(
          'DEBUG: Canjeo realizado, recompensa marcada como usada en memoria',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Has canjeado "${recompensa.nombre}"!')),
        );
        Navigator.pop(context, recompensa);

        print('DEBUG: Navigator.pop(context, true) ejecutado');
      }
    } catch (e) {
      print('DEBUG: Error al canjear -> $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppMessagesConstants.msgPuntosInsuficientes)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = widget.user.rol == AppConstants.rolAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text(recompensa.nombre),
        actions: esAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editarRecompensa,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                   onPressed: () => _eliminarRecompensa(context, recompensa.id),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  recompensa.nombre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '💰 Coste: ${recompensa.coste} puntos',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  AppFieldsConstants.descripcionIcono,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recompensa.descripcion ?? AppFieldsConstants.sinDescripcion,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (!esAdmin)
                  ElevatedButton(
                    onPressed: (recompensa.visible && !recompensa.usada)
                        ? _canjearRecompensa
                        : null,
                    child: const Text(AppFieldsConstants.canjearRecompensa),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
