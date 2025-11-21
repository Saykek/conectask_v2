import 'comida_model.dart';

class MenuDiaModel {
  final String fecha;                  // clave yyyy-MM-dd
  final List<ComidaModel> comidas;     // normalmente 2 platos
  final List<ComidaModel> cenas;       // normalmente 2 platos

  MenuDiaModel({
    required this.fecha,
    List<ComidaModel>? comidas,
    List<ComidaModel>? cenas,
  })  : comidas = comidas ?? [ComidaModel(nombre: ""), ComidaModel(nombre: "")],
        cenas   = cenas   ?? [ComidaModel(nombre: ""), ComidaModel(nombre: "")];

  Map<String, dynamic> toMap() {
    return {
      'comidas': comidas.map((c) => c.toMap()).toList(),
      'cenas': cenas.map((c) => c.toMap()).toList(),
    };
  }

  static MenuDiaModel fromMap(String fecha, Map<String, dynamic>? data) {
  final fechaFormateada = fecha.length > 10
      ? fecha.substring(0, 10)
      : fecha;

  if (data == null) {
    return MenuDiaModel(fecha: fechaFormateada);
  }

  final comidasData = data['comidas'] as List?;
final List<ComidaModel> comidasList = comidasData != null
    ? comidasData
        .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
        .toList()
    : [];

while (comidasList.length < 2) {
  comidasList.add(ComidaModel(nombre: ""));
}

final cenasData = data['cenas'] as List?;
final List<ComidaModel> cenasList = cenasData != null
    ? cenasData
        .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
        .toList()
    : [];

while (cenasList.length < 2) {
  cenasList.add(ComidaModel(nombre: ""));
}

  return MenuDiaModel(
    fecha: fechaFormateada,
    comidas: comidasList,
    cenas: cenasList,
  );
}

  MenuDiaModel copyWith({
    String? fecha,
    List<ComidaModel>? comidas,
    List<ComidaModel>? cenas,
  }) {
    return MenuDiaModel(
      fecha: fecha ?? this.fecha,
      comidas: comidas ?? this.comidas,
      cenas: cenas ?? this.cenas,
    );
  }
}