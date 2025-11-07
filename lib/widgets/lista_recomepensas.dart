import 'package:conectask_v2/models/recompensa_model.dart';
import 'package:flutter/material.dart';

class ListaRecompensas extends StatelessWidget {
  final List<RecompensaModel> recompensas;
  final bool modoAdmin;
  final Function(RecompensaModel)? onTap;

  const ListaRecompensas({
    super.key,
    required this.recompensas,
    required this.modoAdmin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibles = modoAdmin
        ? recompensas
        : recompensas.where((r) => r.visible).toList();

    if (visibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No hay recompensas disponibles',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: visibles.map((r) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              r.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${r.coste} puntos'),
            trailing: modoAdmin
                ? const Icon(Icons.edit, color: Colors.blueAccent)
                : const Icon(Icons.redeem, color: Colors.green),
            onTap: () => onTap?.call(r),
          ),
        );
      }).toList(),
    );
  }
}