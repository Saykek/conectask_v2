import 'comida_model.dart';

class MenuDiaModel {
  final String fecha;        // clave yyyy-MM-dd
  final ComidaModel comida;
  final ComidaModel cena;

  MenuDiaModel({
    required this.fecha,
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

  static MenuDiaModel fromMap(String fecha, Map<String, dynamic>? data) {
    if (data == null) {
      return MenuDiaModel(fecha: fecha);
    }

    return MenuDiaModel(
      fecha: fecha,
      comida: (data['comida'] == null)
          ? ComidaModel(nombre: "")
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['comida'])),
      cena: (data['cena'] == null)
          ? ComidaModel(nombre: "")
          : ComidaModel.fromMap(Map<String, dynamic>.from(data['cena'])),
    );
  }

  MenuDiaModel copyWith({
    String? fecha,
    ComidaModel? comida,
    ComidaModel? cena,
  }) {
    return MenuDiaModel(
      fecha: fecha ?? this.fecha,
      comida: comida ?? this.comida,
      cena: cena ?? this.cena,
    );
  }
}