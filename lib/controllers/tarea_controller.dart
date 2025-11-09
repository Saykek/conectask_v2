import 'package:conectask_v2/models/tarea_model.dart';
import 'package:conectask_v2/services/tarea_sevice.dart';
import 'package:flutter/foundation.dart';

class TareaController extends ChangeNotifier {
  final TareaService _tareaService = TareaService();
  List<Tarea> _tareas = [];

  List<Tarea> get tareas => _tareas;

  TareaController() {
    _escucharTareas();
  }

  void _escucharTareas() {
    _tareaService.escucharTareas().listen((nuevasTareas) {
      _tareas = nuevasTareas;
      notifyListeners();
    });
  }

  Future<void> agregarTarea(Tarea tarea) async {
    await _tareaService.guardarTarea(tarea);
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await _tareaService.actualizarTarea(tarea);
  }

  Future<void> cambiarEstado(Tarea tarea, String nuevoEstado) async {
    await _tareaService.actualizarEstadoTarea(tarea, nuevoEstado);
  }

  Future<void> eliminarTarea(Tarea tarea) async {
    await _tareaService.eliminarTareaDesdeObjeto(tarea);
  }
}
