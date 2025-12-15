import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:conectask_v2/services/user_service.dart';
import 'package:conectask_v2/models/tarea_model.dart';
import '../common/constants/constant.dart';

class TareaService {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref(AppFirebaseConstants.tareas);

  /// Guardar tarea por fecha y responsable y guardar título/puntos en tareasTitulos
  Future<void> guardarTarea(Tarea tarea) async {
    final tituloRef = FirebaseDatabase.instance
        .ref('${AppFirebaseConstants.tareasTitulos}/${tarea.titulo}');
    await tituloRef.set({AppFieldsConstants.puntos: tarea.puntos ?? AppConstants.puntosPorDefecto});

    try {
      final id = const Uuid().v4();
      final fechaKey = DateFormat(AppConstants.formatoFecha).format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(id);

      final data = tarea.toMap();
      data[AppFieldsConstants.id] = id;

      await ref.set(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar cualquier campo de una tarea existente
  Future<void> actualizarTarea(Tarea tarea) async {
    try {
      if (tarea.id.isEmpty) return;

      final fechaKey = DateFormat(AppConstants.formatoFecha).format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(tarea.id);

      await ref.update(tarea.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar solo el estado de la tarea
  Future<void> actualizarEstadoTarea(Tarea tarea, String nuevoEstado) async {
    try {
      if (tarea.id.isEmpty) return;

      final fechaKey = DateFormat(AppConstants.formatoFecha).format(tarea.fecha);
      final ref = _db.child(fechaKey).child(tarea.responsable).child(tarea.id);

      await ref.update({AppFieldsConstants.estado: nuevoEstado});
    } catch (e) {
      rethrow;
    }
  }

  /// Escuchar todas las tareas en tiempo real
  Stream<List<Tarea>> escucharTareas() {
    return _db.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) return <Tarea>[];

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      final List<Tarea> tareas = [];

      data.forEach((fechaKey, usuariosMap) {
        if (usuariosMap is Map) {
          final Map<String, dynamic> usuarios =
              Map<String, dynamic>.from(usuariosMap);
          usuarios.forEach((usuarioKey, tareasMap) {
            if (tareasMap is Map) {
              final Map<String, dynamic> tareasUsuario =
                  Map<String, dynamic>.from(tareasMap);
              tareasUsuario.forEach((id, tareaData) {
                try {
                  final tarea =
                      Tarea.fromMap(Map<String, dynamic>.from(tareaData));
                  if (tarea.id.isNotEmpty &&
                      tarea.titulo.trim().isNotEmpty) {
                    tareas.add(tarea);
                  }
                } catch (_) {}
              });
            }
          });
        }
      });

      return tareas;
    });
  }

  /// Eliminar tarea por claves
  Future<void> eliminarTarea(
      String fecha, String responsable, String idTarea) async {
    await _db.child(fecha).child(responsable).child(idTarea).remove();
  }

  /// Eliminar tarea desde objeto
  Future<void> eliminarTareaDesdeObjeto(Tarea tarea) async {
    final fechaClave = DateFormat(AppConstants.formatoFecha).format(tarea.fecha);
    await _db.child(fechaClave).child(tarea.responsable).child(tarea.id).remove();
  }

  /// Validar tarea
  Future<void> validarTarea(Tarea tarea, String validadorId) async {
    final fechaKey = DateFormat(AppConstants.formatoFecha).format(tarea.fecha);
    final tareaRef =
        _db.child(fechaKey).child(tarea.responsable).child(tarea.id);

    await tareaRef.update({
      AppFieldsConstants.estado: AppConstants.estadoValidada,
      AppFieldsConstants.validadaPor: validadorId,
    });

    if (tarea.puntos != null && tarea.puntos! > 0) {
      final userService = UserService();
      await userService.sumarPuntos(tarea.responsable, tarea.puntos!);
    }
  }

  /// Obtener títulos de tareas
  Future<List<String>> obtenerTitulosDeTareas() async {
    final snapshot = await _db.get();
    final Set<String> titulos = {};

    if (snapshot.exists) {
      for (final fechaEntry in snapshot.children) {
        for (final userEntry in fechaEntry.children) {
          for (final tareaEntry in userEntry.children) {
            final datos = tareaEntry.value as Map;
            final titulo = datos[AppFieldsConstants.titulo]?.toString().trim();
            if (titulo != null && titulo.isNotEmpty) {
              titulos.add(titulo);
            }
          }
        }
      }
    }

    return titulos.toList();
  }

  /// Obtener títulos con puntos
  Future<Map<String, int>> obtenerTitulosConPuntos() async {
    final ref = FirebaseDatabase.instance.ref(AppFirebaseConstants.tareasTitulos);
    final snapshot = await ref.get();

    final Map<String, int> titulos = {};

    if (snapshot.exists) {
      for (final entrada in snapshot.children) {
        final titulo = entrada.key;
        final value = entrada.value;
        if (value is Map) {
          final puntos = value[AppFieldsConstants.puntos];
          if (titulo != null && puntos is int) {
            titulos[titulo] = puntos;
          } else if (titulo != null && puntos != null) {
            titulos[titulo] = int.tryParse(puntos.toString()) ?? 0;
          }
        }
      }
    }

    return titulos;
  }
}