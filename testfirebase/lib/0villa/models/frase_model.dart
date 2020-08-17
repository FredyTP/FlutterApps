class FraseModel {
  final String frase;
  final int numero;
  final String creador;

  FraseModel({this.frase, this.numero, this.creador = "Anónimo"});

  FraseModel.fromJson(Map<String, dynamic> json)
      : frase = json["frase"],
        numero = json["numero"],
        creador = json["creador"];

  Map<String, dynamic> toJson() {
    return {"frase": frase, "numero": numero, "creador": creador};
  }
}
