import 'package:YoNunca/src/models/chat_msg.dart';

class ChatModel {
  final List<String> users;
  final List<ChatMsg> messages;

  ChatModel({this.users, this.messages = const <ChatMsg>[]});

  ChatModel.fromJson(Map<String, dynamic> json)
      : users = json["users"].cast<String>(),
        messages = json["messages"]?.map((e) => ChatMsg.fromJson(e))?.toList()?.cast<ChatMsg>() ?? <ChatMsg>[];

  Map<String, dynamic> toJson() {
    return {"users": users, "messages": messages.map((e) => e.toJson()).toList()};
  }
}
