import 'package:flutter/material.dart';

class TiraDiasWidget extends StatefulWidget {
  final List<DateTime> fechas;
  final DateTime diaSeleccionado;
  final Function(DateTime) onSelectDia;

  const TiraDiasWidget({
    super.key,
    required this.fechas,
    required this.diaSeleccionado,
    required this.onSelectDia,
  });

  @override
  State<TiraDiasWidget> createState() => _TiraDiasWidgetState();
}

class _TiraDiasWidgetState extends State<TiraDiasWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final indexHoy = widget.fechas.indexWhere(
        (f) =>
            f.day == DateTime.now().day &&
            f.month == DateTime.now().month &&
            f.year == DateTime.now().year,
      );

      if (indexHoy != -1) {
        _scrollController.jumpTo(indexHoy * 70.0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool esHoy(DateTime fecha) {
    final hoy = DateTime.now();
    return fecha.day == hoy.day &&
        fecha.month == hoy.month &&
        fecha.year == hoy.year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: false,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.fechas.length,
          itemBuilder: (context, index) {
            final fecha = widget.fechas[index];
            final letra = [
              'L',
              'M',
              'X',
              'J',
              'V',
              'S',
              'D',
            ][fecha.weekday - 1];
            final isSelected =
                fecha.day == widget.diaSeleccionado.day &&
                fecha.month == widget.diaSeleccionado.month &&
                fecha.year == widget.diaSeleccionado.year;

            return GestureDetector(
              onTap: () => widget.onSelectDia(fecha),
              child: Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  children: [
                    Text(letra, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: esHoy(fecha)
                          ? Theme.of(context).colorScheme.secondary
                          : (isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300),
                      child: Text(
                        fecha.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: (esHoy(fecha) || isSelected)
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
