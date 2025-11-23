import 'comida_model.dart';

class MenuDiaModel {
  final String fecha; // clave yyyy-MM-dd
  final List<ComidaModel> comidas; // normalmente 2 platos
  final List<ComidaModel> cenas; // normalmente 2 platos

  MenuDiaModel({
    required this.fecha,
    List<ComidaModel>? comidas,
    List<ComidaModel>? cenas,
  }) : comidas = comidas ?? [ComidaModel(nombre: ""), ComidaModel(nombre: "")],
       cenas = cenas ?? [ComidaModel(nombre: ""), ComidaModel(nombre: "")];

  Map<String, dynamic> toMap() {
    return {
      'comidas': {
        for (int i = 0; i < comidas.length; i++) '$i': comidas[i].toMap(),
      },
      'cenas': {for (int i = 0; i < cenas.length; i++) '$i': cenas[i].toMap()},
    };
  }

  static MenuDiaModel fromMap(String fecha, Map<String, dynamic>? data) {
    final fechaFormateada = fecha.length > 10 ? fecha.substring(0, 10) : fecha;

    if (data == null) {
      return MenuDiaModel(fecha: fechaFormateada);
    }

    // --- Comidas ---
    final comidasRaw = data['comidas'];
    List<ComidaModel> comidasList = [];

    if (comidasRaw is List) {
      comidasList = comidasRaw
          .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    } else if (comidasRaw is Map) {
      comidasList = comidasRaw.values
          .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    }

    while (comidasList.length < 2) {
      comidasList.add(ComidaModel(nombre: ""));
    }

    // --- Cenas ---
    final cenasRaw = data['cenas'];
    List<ComidaModel> cenasList = [];

    if (cenasRaw is List) {
      cenasList = cenasRaw
          .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    } else if (cenasRaw is Map) {
      cenasList = cenasRaw.values
          .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    }

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
