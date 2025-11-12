import 'package:conectask_v2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:conectask_v2/models/examen_model.dart';

class ColegioController extends ChangeNotifier {
  List<Examen> examenes = [];
  List<UserModel> usuariosLocales = [];
  DateTime fechaSeleccionada = DateTime.now();

  void setFechaSeleccionada(DateTime nuevaFecha) {
    fechaSeleccionada = nuevaFecha;
    notifyListeners();
  }

  void cargarExamenes(List<Examen> nuevosExamenes) {
    examenes = nuevosExamenes;
    notifyListeners();
  }

  void cargarUsuarios(List<UserModel> nuevosUsuarios) {
    usuariosLocales = nuevosUsuarios;
    notifyListeners();
  }

  List<Examen> examenesFiltradosPorUsuario(String? id) {
    if (id == null) return examenes;
    return examenes.where((e) => e.responsable == id).toList();
  }
}