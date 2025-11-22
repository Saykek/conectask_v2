import 'package:firebase_database/firebase_database.dart';
import '../models/menu_dia_model.dart';

class MenuSemanalService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<MenuDiaModel>> leerMenu() async {
    final snapshot = await _db.child('menuSemanal').get();
    print("📥 Snapshot bruto: ${snapshot.value}");

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      print("📦 Data parseada: $data");

      return data.entries.map((entry) {
        final fecha = entry.key;
        final valores = Map<String, dynamic>.from(entry.value);
        print("➡️ Día leído: $fecha -> $valores");
        return MenuDiaModel.fromMap(fecha, valores);
      }).toList();
    }

    print("⚠️ No hay datos en Firebase");
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
