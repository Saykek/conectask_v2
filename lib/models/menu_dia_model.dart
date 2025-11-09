import 'package:conectask_v2/models/comida_model.dart';

class MenuDiaModel {
  final String dia;
  ComidaModel? almuerzo;
  ComidaModel? cena;

  MenuDiaModel({required this.dia, this.almuerzo, this.cena});

  Map<String, dynamic> toMap() {
    return {
      if (almuerzo != null) 'almuerzo': almuerzo!.toMap(),
      if (cena != null) 'cena': cena!.toMap(),
    };
  }

  static MenuDiaModel fromMap(String dia, Map<String, dynamic>? data) {
    if (data == null) {
      return MenuDiaModel(dia: dia);
    }

    return MenuDiaModel(
      dia: dia,
      almuerzo: data['almuerzo'] == null
          ? null
          : data['almuerzo'] is String
          ? ComidaModel(nombre: data['almuerzo'])
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['almuerzo'])),
      cena: data['cena'] == null
          ? null
          : data['cena'] is String
          ? ComidaModel(nombre: data['cena'])
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['cena'])),
    );
  }
}
