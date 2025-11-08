class MenuDiaModel {
  final String dia;
  String almuerzo;
  String cena;
  String? recetaAlmuerzo;
  String? recetaCena;

  MenuDiaModel({
    required this.dia,
    this.almuerzo = '',
    this.cena = '',
    this.recetaAlmuerzo,
    this.recetaCena,
  });

  Map<String, dynamic> toMap() {
    return {
      'almuerzo': almuerzo,
      'cena': cena,
      if (recetaAlmuerzo != null) 'recetaAlmuerzo': recetaAlmuerzo,
      if (recetaCena != null) 'recetaCena': recetaCena,
    };
  }

  static MenuDiaModel fromMap(String dia, Map<String, dynamic> data) {
    return MenuDiaModel(
      dia: dia,
      almuerzo: data['almuerzo'] ?? '',
      cena: data['cena'] ?? '',
      recetaAlmuerzo: data['recetaAlmuerzo'],
      recetaCena: data['recetaCena'],
    );
  }
}
