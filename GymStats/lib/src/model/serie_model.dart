class SerieModel {
  final String exerciseID;
  final int reps;
  final double weight;
  final DateTime timestamp;

  SerieModel({this.exerciseID, this.reps, this.timestamp, this.weight});

  SerieModel.fromJson(Map<String, dynamic> json)
      : this.exerciseID = json["exerciseID"],
        this.reps = json["reps"],
        this.weight = json["weight"],
        this.timestamp = DateTime.fromMillisecondsSinceEpoch(json["timestamp"]);

  Map<String, dynamic> toJson() {
    return {
      "exerciseID": this.exerciseID,
      "reps": this.reps,
      "weight": this.weight,
      "timestamp": this.timestamp.millisecondsSinceEpoch,
    };
  }
}
