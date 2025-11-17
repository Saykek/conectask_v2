import 'package:flutter/material.dart';
import '../models/comida_model.dart';

class Autocompletar extends StatelessWidget {
  final String label;
  final String? initial;
  final List<ComidaModel> recetasDisponibles;
  final ValueChanged<String> onChanged;        // 👈 más claro que Function(String)
  final ValueChanged<ComidaModel> onSelected;  // 👈 más claro que Function(ComidaModel)

  const Autocompletar({
    super.key,
    required this.label,
    this.initial,
    required this.recetasDisponibles,
    required this.onChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<ComidaModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<ComidaModel>.empty();
        }
        return recetasDisponibles.where(
          (receta) => (receta.nombre ?? '')
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      displayStringForOption: (ComidaModel receta) => receta.nombre ?? '',
      onSelected: (ComidaModel receta) => onSelected(receta),
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        if (initial != null && textController.text.isEmpty) {
          textController.text = initial!;
        }
        return TextField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Escribe o selecciona',
          ),
          onChanged: (value) => onChanged(value),
        );
      },
    );
  }
}