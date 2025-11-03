import 'package:firebase_database/firebase_database.dart';
import '../models/tarea_model.dart';

class TareaService {
  final DatabaseReference tareasRef = FirebaseDatabase.instance.ref().child(
    'tareas',
  );

  // Guardar o actualizar una tarea
  Future<void> guardarTarea(Tarea tarea) async {
    try {
      await tareasRef.child(tarea.id).set(tarea.toMap());
    } catch (e) {
      print('Error al guardar tarea: $e');
      rethrow;
    }
  }

  // Obtener todas las tareas
  Future<List<Tarea>> obtenerTareas() async {
    try {
      final snapshot = await tareasRef.get();
      if (snapshot.exists) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(
          snapshot.value as Map,
        );
        return map.values
            .map((t) => Tarea.fromMap(Map<String, dynamic>.from(t)))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener tareas: $e');
      rethrow;
    }
  }

  // Eliminar una tarea
  Future<void> eliminarTarea(String id) async {
    try {
      await tareasRef.child(id).remove();
    } catch (e) {
      print('Error al eliminar tarea: $e');
      rethrow;
    }
  }
}
