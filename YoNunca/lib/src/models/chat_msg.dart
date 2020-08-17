class ChatMsg {
  String msg;
  String uid;
  DateTime timeStamp;

  ChatMsg({this.msg, this.timeStamp, this.uid});

  ChatMsg.fromJson(Map<String, dynamic> json)
      : msg = json["msg"],
        uid = json["uid"],
        timeStamp = DateTime.fromMillisecondsSinceEpoch(json["timeStamp"]);

  Map<String, dynamic> toJson() {
    return {"msg": msg, "uid": uid, "timeStamp": timeStamp.millisecondsSinceEpoch};
  }
}
