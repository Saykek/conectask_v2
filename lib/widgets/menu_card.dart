import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/comida_model.dart';

class MenuCard extends StatelessWidget {
  final ComidaModel? comida;
  final VoidCallback? onTap;

  const MenuCard({super.key, required this.comida, this.onTap});

  Future<void> _abrirReceta(BuildContext context) async {
    if (comida?.url != null && comida!.url!.isNotEmpty) {
      final uri = Uri.parse(comida!.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay receta disponible')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
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
              Tooltip(
                message: "Ver receta",
                child: IconButton(
                  icon: const Icon(Icons.receipt_long),
                  onPressed: () => _abrirReceta(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}