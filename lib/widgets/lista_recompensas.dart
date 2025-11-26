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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibles.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final r = visibles[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          title: Text(
            r.nombre,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('${r.coste} puntos'),
          trailing: modoAdmin
              ? const Icon(Icons.edit, size: 20, color: Colors.blueAccent)
              : const Icon(Icons.redeem, size: 20, color: Colors.green),
          onTap: () => onTap?.call(r),
        );
      },
    );
  }
}
