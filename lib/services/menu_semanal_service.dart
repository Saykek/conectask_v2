import 'package:firebase_database/firebase_database.dart';
import '../models/menu_dia_model.dart';

class MenuSemanalService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  /// Leer todos los menús guardados en Firebase
  Future<List<MenuDiaModel>> leerMenu() async {
    final snapshot = await _db.child('menuSemanal').get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      return data.entries.map((entry) {
        final fecha = entry.key; // ahora la clave es yyyy-MM-dd
        final valores = Map<String, dynamic>.from(entry.value);
        return MenuDiaModel.fromMap(fecha, valores);
      }).toList();
    }

    return [];
  }

  /// Guardar un conjunto de menús en Firebase
  Future<void> guardarMenu(Map<String, dynamic> data) async {
    await _db.child('menuSemanal').set(data);
  }

  /// Guardar un único día
  Future<void> guardarMenuDia(MenuDiaModel menuDia) async {
    await _db
        .child('menuSemanal')
        .child(menuDia.fecha) // clave yyyy-MM-dd
        .set(menuDia.toMap());
  }

  /// Leer un único día
  Future<MenuDiaModel?> leerMenuDia(String fecha) async {
    final snapshot = await _db.child('menuSemanal').child(fecha).get();

    if (snapshot.exists && snapshot.value is Map) {
      final valores = Map<String, dynamic>.from(snapshot.value as Map);
      return MenuDiaModel.fromMap(fecha, valores);
    }
    return null;
  }
}
