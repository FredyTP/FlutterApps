class FriendRequestModel {
  final String userUID;
  final String msg;

  FriendRequestModel({this.userUID, this.msg = "Hola. ¿Quieres agregarme a amigos?"});

  FriendRequestModel.fromJson(Map<String, dynamic> json)
      : userUID = json["userUID"] ?? "Error",
        msg = json["msg"] ?? "Anónimo";

  Map<String, dynamic> toJson() {
    return {"msg": msg, "userUID": userUID};
  }
}
