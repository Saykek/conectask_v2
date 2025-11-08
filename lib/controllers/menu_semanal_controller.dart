import 'package:conectask_v2/models/menu_dia_model.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuSemanalController {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<MenuDiaModel>> cargarMenu() async {
    final snapshot = await _db.child('menuSemanal').get();
    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries.map((e) {
      final dia = e.key;
      final valores = Map<String, dynamic>.from(e.value);
      return MenuDiaModel.fromMap(dia, valores);
    }).toList();
  }

  Future<void> guardarMenu(List<MenuDiaModel> menu) async {
    final data = {for (var dia in menu) dia.dia: dia.toMap()};
    await _db.child('menuSemanal').set(data);
  }
}
