import 'package:firebase_database/firebase_database.dart';
import '../models/menu_dia_model.dart';

class MenuSemanalService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<MenuDiaModel>> leerMenu() async {
    final snapshot = await _db.child('menuSemanal').get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        final dia = entry.key;
        final valores = Map<String, dynamic>.from(entry.value);
        return MenuDiaModel.fromMap(dia, valores); // ✅ corregido
      }).toList();
    }

    return [];
  }

  Future<void> guardarMenu(Map<String, dynamic> data) async {
    await _db.child('menuSemanal').set(data);
  }
}
