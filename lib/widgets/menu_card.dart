import 'package:flutter/material.dart';
import '../models/comida_model.dart';

class MenuCard extends StatelessWidget {
  final ComidaModel? comida;

  const MenuCard({
    super.key,
    required this.comida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                image: comida?.foto != null
                    ? DecorationImage(
                        image: NetworkImage(comida!.foto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: comida?.foto == null
                  ? const Icon(Icons.fastfood, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                comida?.nombre ?? 'Sin asignar',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}