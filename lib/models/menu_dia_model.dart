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
  // Normaliza la fecha al formato yyyy-MM-dd
  final fechaFormateada = fecha.length > 10
      ? fecha.substring(0, 10) // si viene como ISO completo
      : fecha;

  if (data == null) {
    return MenuDiaModel(fecha: fechaFormateada);
  }

  final comidasData = data['comidas'] as List?;
  final cenasData = data['cenas'] as List?;

  return MenuDiaModel(
    fecha: fechaFormateada,
    comidas: comidasData != null && comidasData.isNotEmpty
        ? comidasData
            .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
            .toList()
        : [ComidaModel(nombre: ""), ComidaModel(nombre: "")],
    cenas: cenasData != null && cenasData.isNotEmpty
        ? cenasData
            .map((c) => ComidaModel.fromMap(Map<String, dynamic>.from(c)))
            .toList()
        : [ComidaModel(nombre: ""), ComidaModel(nombre: "")],
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