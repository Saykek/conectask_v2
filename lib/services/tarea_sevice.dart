import 'package:firebase_database/firebase_database.dart';
import '../models/tarea_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class TareaService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('tareas');

  /// Guardar tarea por fecha y responsable
  Future<void> guardarTarea(Tarea tarea) async {
    try {
      print('➡️ Intentando guardar tarea...');

      final id = const Uuid().v4();
      final fechaKey = DateFormat('yyyy-MM-dd').format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(id);

      final data = tarea.toMap();
      data['id'] = id;

      await ref.set(data);

      print('✅ Tarea guardada correctamente con ID: $id');
    } catch (e) {
      print('❌ Error al guardar tarea: $e');
      rethrow;
    }
  }

  /// Actualizar cualquier campo de una tarea existente
  Future<void> actualizarTarea(Tarea tarea) async {
    try {
      final fechaKey = DateFormat('yyyy-MM-dd').format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(tarea.id);
      await ref.update(tarea.toMap());
      print('✅ Tarea actualizada: ${tarea.titulo}');
    } catch (e) {
      print('❌ Error al actualizar tarea: $e');
      rethrow;
    }
  }

  /// Actualizar solo el estado de la tarea ("pendiente", "hecha", etc.)
  Future<void> actualizarEstadoTarea(Tarea tarea, String nuevoEstado) async {
    try {
      final fechaKey = DateFormat('yyyy-MM-dd').format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(tarea.id);
      await ref.update({'estado': nuevoEstado});
      print('✅ Estado actualizado a $nuevoEstado para tarea ${tarea.titulo}');
    } catch (e) {
      print('❌ Error al actualizar estado: $e');
    }
  }

  /// Escuchar todas las tareas en tiempo real (de todas las fechas y usuarios)
  Stream<List<Tarea>> escucharTareas() {
    return _db.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) {
        print('⚠️ No hay datos en Firebase.');
        return <Tarea>[];
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.value as Map,
      );
      final List<Tarea> tareas = [];

      print('📡 Datos recibidos desde Firebase: $data');

      // Recorrer estructura: fecha → usuario → idTarea → datos
      data.forEach((fechaKey, usuariosMap) {
        if (usuariosMap is Map) {
          final Map<String, dynamic> usuarios = Map<String, dynamic>.from(
            usuariosMap,
          );

          usuarios.forEach((usuarioKey, tareasMap) {
            if (tareasMap is Map) {
              final Map<String, dynamic> tareasUsuario =
                  Map<String, dynamic>.from(tareasMap);

              tareasUsuario.forEach((id, tareaData) {
                try {
                  final tarea = Tarea.fromMap(
                    Map<String, dynamic>.from(tareaData),
                  );
                  tareas.add(tarea);
                } catch (e) {
                  print('❌ Error parseando tarea $id: $e');
                }
              });
            }
          });
        }
      });

      print('✅ ${tareas.length} tareas cargadas desde Firebase');
      return tareas;
    });
  }
}
