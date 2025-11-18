import 'package:conectask_v2/models/comida_model.dart';

class MenuDiaModel {
  final String dia;
  ComidaModel comida;
  ComidaModel cena;

  MenuDiaModel({
    required this.dia,
    ComidaModel? comida,
    ComidaModel? cena,
  })  : comida = comida ?? ComidaModel(nombre: ""),
        cena = cena ?? ComidaModel(nombre: "");

  Map<String, dynamic> toMap() {
    return {
      'comida': comida.toMap(),
      'cena': cena.toMap(),
    };
  }

  static MenuDiaModel fromMap(String dia, Map<String, dynamic>? data) {
    if (data == null) {
      return MenuDiaModel(dia: dia);
    }

    return MenuDiaModel(
      dia: dia,
      comida: (data['comida'] == null)
          ? ComidaModel(nombre: "")
          : (data['comida'] is String
              ? ComidaModel(nombre: data['comida'])
              : ComidaModel.fromMap(Map<String, dynamic>.from(data['comida']))),
      cena: (data['cena'] == null)
          ? ComidaModel(nombre: "")
          : (data['cena'] is String
              ? ComidaModel(nombre: data['cena'])
              : ComidaModel.fromMap(Map<String, dynamic>.from(data['cena']))),
    );
  }
}