import 'package:conectask_v2/models/comida_model.dart';

class MenuDiaModel {
  final String dia;
  ComidaModel? comida;
  ComidaModel? cena;

  MenuDiaModel({required this.dia, this.comida, this.cena});

  Map<String, dynamic> toMap() {
    return {
      if (comida != null) 'comida': comida!.toMap(),
      if (cena != null) 'cena': cena!.toMap(),
    };
  }

  static MenuDiaModel fromMap(String dia, Map<String, dynamic>? data) {
    if (data == null) {
      return MenuDiaModel(dia: dia);
    }

    return MenuDiaModel(
      dia: dia,
      comida: data['comida'] == null
          ? null
          : data['comida'] is String
          ? ComidaModel(nombre: data['comida'])
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['comida'])),
      cena: data['cena'] == null
          ? null
          : data['cena'] is String
          ? ComidaModel(nombre: data['cena'])
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['cena'])),
    );
  }
}
