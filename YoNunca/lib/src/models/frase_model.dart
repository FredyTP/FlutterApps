class FraseModel {
  final String frase;
  final String uid;
  final bool pending;
  final num rating;
  final int votes;

  FraseModel({this.frase, this.uid = "Anónimo", this.pending = true, this.rating = 0, this.votes = 0});

  FraseModel.fromJson(Map<String, dynamic> json)
      : frase = json["frase"] ?? "Error",
        uid = json["uid"] ?? "Anónimo",
        pending = json["pending"] ?? true,
        rating = json["rating"] ?? 0,
        votes = json["votes"] ?? 0;

  Map<String, dynamic> toJson() {
    return {"frase": frase, "uid": uid, "pending": pending, "rating": rating, "votes": votes};
  }
}

class NumFrasesResult {
  final int aproved;
  final int pending;
  NumFrasesResult({this.aproved, this.pending});
}
