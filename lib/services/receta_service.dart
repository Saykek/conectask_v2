

import 'package:conectask_v2/models/comida_model.dart';
import 'package:firebase_database/firebase_database.dart';

class RecetaService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<ComidaModel>> leerRecetas() async {
    final snapshot = await _db.child('recetas').get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.values.map((valores) {
        return ComidaModel.fromMap(Map<String, dynamic>.from(valores));
      }).toList();
    }
    return [];
  }

  Future<void> guardarReceta(ComidaModel comida) async {
    await _db.child('recetas').child(comida.nombre.toLowerCase()).set(comida.toMap());
  }
}