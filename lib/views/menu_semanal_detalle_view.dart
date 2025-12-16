import 'package:flutter/material.dart';
import 'package:conectask_v2/models/comida_model.dart';
import '../common/constants/constant.dart';

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
        title: Text('${AppFieldsConstants.anadir} $titulo'),

        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: '${AppFieldsConstants.hintEscribeAqui} $titulo',),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppFieldsConstants.cancelar),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoTexto = controller.text;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$titulo ${AppFieldsConstants.anadido}: $nuevoTexto')),
              );
              Navigator.pop(context);
            },
            child: const Text(AppFieldsConstants.guardar),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppFieldsConstants.detalleMenu)),
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
                comida?.nombre ?? AppFieldsConstants.sinAsignar,
                style: textTheme.titleMedium?.copyWith(fontSize: 22),
              ),

              const SizedBox(height: 24),

              // Ingredientes con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppFieldsConstants.ingredientes, style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: AppFieldsConstants.toolanadirIngredientes,
                    onPressed: () =>
                        _abrirDialogo(context, AppFieldsConstants.ingredientesMin, AppFieldsConstants.ingredientesMin),
                  ),
                ],
              ),
              Text(
                comida?.ingredientes ?? AppFieldsConstants.noEspecificados,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Receta con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppFieldsConstants.receta, style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: AppFieldsConstants.anadirReceta,
                    onPressed: () => _abrirDialogo(context, AppFieldsConstants.recetaMin, AppFieldsConstants.recetaMin),
                  ),
                ],
              ),
              Text(
                comida?.receta ?? AppFieldsConstants.noDisponible,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Notas con botón +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppFieldsConstants.notas, style: textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: AppFieldsConstants.toolAnadirNotas,
                    onPressed: () => _abrirDialogo(context, AppFieldsConstants.notasMin, AppFieldsConstants.notasMin),
                  ),
                ],
              ),
              Text(comida?.notas ?? AppFieldsConstants.sinNotas, style: textTheme.bodyMedium),

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
