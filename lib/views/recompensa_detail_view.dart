import 'package:conectask_v2/views/recompensa_add_view.dart';
import 'package:flutter/material.dart';
import '../models/recompensa_model.dart';
import '../models/user_model.dart';
import '../services/recompensa_service.dart';

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
  final RecompensaService _recompensaService = RecompensaService();
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

  Future<void> _eliminarRecompensa() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar recompensa'),
        content: const Text('¿Seguro que quieres eliminar esta recompensa?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _recompensaService.eliminarRecompensa(recompensa.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recompensa eliminada correctamente')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _canjearRecompensa() {
    if ((widget.user.puntos ?? 0) >= recompensa.coste) {
      // Aquí iría la lógica de canjeo y actualización de puntos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Has canjeado "${recompensa.nombre}"!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tienes suficientes puntos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = widget.user.rol == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(recompensa.nombre),
        actions: esAdmin
            ? [
                IconButton(icon: const Icon(Icons.edit), onPressed: _editarRecompensa),
                IconButton(icon: const Icon(Icons.delete), onPressed: _eliminarRecompensa),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  recompensa.nombre,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('💰 Coste: ${recompensa.coste} puntos', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  '📝 Descripción:',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(recompensa.descripcion ?? 'Sin descripción', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                if (!esAdmin)
                  ElevatedButton(
                    onPressed: recompensa.visible ? _canjearRecompensa : null,
                    child: const Text('Canjear recompensa'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}