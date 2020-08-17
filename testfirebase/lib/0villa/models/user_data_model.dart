class UserData {
  final String email;
  final String uid;
  final int level;

  UserData({this.email, this.level = 0, this.uid});

  UserData.fromJson(Map<String, dynamic> json)
      : this.email = json["email"],
        this.level = json["level"],
        this.uid = json["uid"];

  Map<String, dynamic> toJson() {
    return {"email": this.email, "level": this.level, "uid": this.uid};
  }
}
