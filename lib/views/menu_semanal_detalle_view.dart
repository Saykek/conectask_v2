import 'package:flutter/material.dart';
import '../models/comida_model.dart';

class MenuSemanalDetalleView extends StatelessWidget {
  final String nombreDia;
  final ComidaModel? comida;

  const MenuSemanalDetalleView({
    super.key,
    required this.nombreDia,
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
              // Aquí guardarías el texto en tu modelo/base de datos
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
    return Scaffold(
      appBar: AppBar(title: Text('Detalle del $nombreDia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto grande
            if (comida?.foto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
              ),

            const SizedBox(height: 16),

            // Nombre del plato
            Text(
              comida?.nombre ?? 'Sin asignar',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Ingredientes con botón +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ingredientes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: "Añadir ingredientes",
                  onPressed: () => _abrirDialogo(context, "ingredientes", "ingredientes"),
                ),
              ],
            ),
            Text(comida?.ingredientes ?? 'No especificados'),

            const SizedBox(height: 24),

            // Receta con botón +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Receta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: "Añadir receta",
                  onPressed: () => _abrirDialogo(context, "receta", "receta"),
                ),
              ],
            ),
            Text(comida?.receta ?? 'No disponible'),

            const SizedBox(height: 24),

            // Notas con botón +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Notas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: "Añadir notas",
                  onPressed: () => _abrirDialogo(context, "notas", "notas"),
                ),
              ],
            ),
            Text(comida?.notas ?? 'Sin notas'),
          ],
        ),
      ),
    );
  }
}