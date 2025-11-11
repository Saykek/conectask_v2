import 'package:conectask_v2/models/tarea_model.dart';
import 'package:conectask_v2/services/tarea_sevice.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TareaController extends ChangeNotifier {
  final TareaService _tareaService = TareaService();
  List<Tarea> _tareas = [];

  DateTime _fechaSeleccionada = DateTime.now();
  DateTime get fechaSeleccionada => _fechaSeleccionada;

  List<Tarea> get tareas => _tareas;

  List<Tarea> get tareasDelDia {
  final formato = DateFormat('yyyy-MM-dd');
  final fechaFiltrada = formato.format(_fechaSeleccionada);
  return _tareas.where((t) {
    try {
      return formato.format(t.fecha) == fechaFiltrada;
    } catch (_) {
      return false;
    }
  }).toList();
}

    

  void setFechaSeleccionada(DateTime nuevaFecha) {
    _fechaSeleccionada = nuevaFecha;
    notifyListeners();
  }


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

// **************  TASK EDIT ************** 

  Future<void> guardarTareaDesdeFormulario(Tarea tarea, {required bool esNueva}) async {
  if (esNueva) {
    await agregarTarea(tarea);
  } else {
    await actualizarTarea(tarea);
  }
}
}
