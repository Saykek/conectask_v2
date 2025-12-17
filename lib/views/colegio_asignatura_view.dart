import 'package:conectask_v2/common/widgets/tarjeta_base_colegio.dart';
import 'package:flutter/material.dart';
import '../common/constants/constant.dart';
import '../models/asignatura_model_mock.dart';


class ColegioAsignaturaView extends StatelessWidget {
  final AsignaturaModelMock asignatura;

  const ColegioAsignaturaView({super.key, required this.asignatura});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = (screenWidth * 0.02).clamp(8.0, 16.0);

    // Ordenar exámenes por fecha ascendente (null al final)
    final examenesOrdenados = List.from(asignatura.examenes)
      ..sort((a, b) {
        final fechaA = a[AppFieldsConstants.fecha] ?? '';
        final fechaB = b[AppFieldsConstants.fecha] ?? '';
        return fechaA.compareTo(fechaB);
      });

    // Ordenar notas por fecha descendente (null al final)
    final notasOrdenadas = List.from(asignatura.notas)
      ..sort((a, b) {
        final fechaA = a[AppFieldsConstants.fecha] ?? '';
        final fechaB = b[AppFieldsConstants.fecha] ?? '';
        return fechaB.compareTo(fechaA);
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(asignatura.nombre),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(asignatura.icono, size: 28),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing),
        children: [
          // ✅ Card Exámenes
          TarjetaBaseColegio(
            color: Colors.blue.shade100,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset(
                    AppIconsConstants.examen,
                    width: 32,
                    height: 32,
                  ),
                  title: const Text(
                    AppFieldsConstants.examenes,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ...examenesOrdenados.map((ex) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text('${ex[AppFieldsConstants.titulo] ?? ''} • Fecha: ${ex[AppFieldsConstants.fecha] ?? '—'}'),
                    )),
              ],
            ),
          ),
          SizedBox(height: spacing),

    // ✅ Card Notas
TarjetaBaseColegio(
  color: Colors.green.shade100,
  onTap: () {},
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Encabezado de la card con icono
      ListTile(
        leading: Image.asset(
          AppIconsConstants.nota, 
          width: 32,
          height: 32,
        ),
        title: const Text(
          AppFieldsConstants.notas,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      // Lista de notas
      ...notasOrdenadas.map((n) {
        final titulo = n[AppFieldsConstants.titulo] ?? '';
        final fecha = n[AppFieldsConstants.fecha] ?? ''; // fecha real
        final nota = n[AppFieldsConstants.notaMin] ?? '—';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila con título y fecha
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fecha, // fecha real al lado del título
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Nota debajo
              Text('Nota: $nota'),
            ],
          ),
        );
      }),
    ],
  ),
),




          SizedBox(height: spacing),

          // ✅ Card Excursiones
          TarjetaBaseColegio(
            color: Colors.orange.shade100,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.hiking, color: Colors.orange, size: 32),
               
                  
                  title: const Text(
                    'Excursiones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ...asignatura.excursiones.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text('${e['titulo'] ?? ''} • Fecha: ${e['fecha'] ?? '—'}'),
                    )),
              ],
            ),
          ),
          SizedBox(height: spacing),

          // ✅ Card Tiempo de lectura
          TarjetaBaseColegio(
            color: Colors.purple.shade100,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.timer, color: Colors.purple, size: 32),
                  title: Text(
                    'Tiempo de lectura',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('—'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


