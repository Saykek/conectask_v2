import 'package:flutter/material.dart';
import 'package:conectask_v2/models/comida_model.dart';

class MenuSemanalDetalleView extends StatelessWidget {
  final String fecha; // clave yyyy-MM-dd
  final ComidaModel? comida;

  const MenuSemanalDetalleView({
    super.key,
    required this.fecha,
    required this.comida,
  });

  void _abrirDialogo(BuildContext context, String titulo, String campo) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Añadir $titulo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Escribe aquí tu $titulo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoTexto = controller.text;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$titulo añadido: $nuevoTexto')),
              );
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Detalle del menú')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto grande
              if (comida?.foto != null && comida!.foto!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    comida!.foto!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.fastfood,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(height: 16),

              // Nombre del plato
              Text(
                comida?.nombre ?? 'Sin asignar',
                style: textTheme.titleMedium?.copyWith(fontSize: 22),
              ),

              const SizedBox(height: 24),

              // Ingredientes con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ingredientes", style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: "Añadir ingredientes",
                    onPressed: () =>
                        _abrirDialogo(context, "ingredientes", "ingredientes"),
                  ),
                ],
              ),
              Text(
                comida?.ingredientes ?? 'No especificados',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Receta con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Receta", style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: "Añadir receta",
                    onPressed: () => _abrirDialogo(context, "receta", "receta"),
                  ),
                ],
              ),
              Text(
                comida?.receta ?? 'No disponible',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Notas con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Notas", style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: "Añadir notas",
                    onPressed: () => _abrirDialogo(context, "notas", "notas"),
                  ),
                ],
              ),
              Text(comida?.notas ?? 'Sin notas', style: textTheme.bodyMedium),

              const SizedBox(height: 24),

              // URL de receta (al final, discreta)
              if (comida?.url != null && comida!.url!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.link, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        comida!.url!,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.blueGrey,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
