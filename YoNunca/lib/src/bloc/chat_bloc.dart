import 'package:YoNunca/src/models/chat_model.dart';
import 'package:YoNunca/src/models/chat_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBloc {
  final _chatCollection = Firestore.instance.collection("Chats");

  Future<DocumentReference> createChat({String uid1, String uid2}) async {
    final chat = ChatModel(users: [uid1, uid2]);
    return await _chatCollection.add(chat.toJson());
  }

  Future<DocumentReference> findChat({String uid1, String uid2}) async {
    try {
      final List<DocumentSnapshot> chats = (await _chatCollection.where("users", arrayContains: uid1).getDocuments()).documents;
      DocumentSnapshot chatResult;
      for (final chat in chats) {
        if (chat.data["users"].contains(uid2)) {
          chatResult = chat;
        }
      }
      return chatResult?.reference;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<DocumentReference>> findChats({String uid}) async {
    final List<DocumentSnapshot> chats = (await _chatCollection.where("users", arrayContains: uid).getDocuments()).documents;
    return chats.map((e) => e.reference).toList();
  }

  Stream<List<ChatModel>> getUserChatsStream({String uid}) {
    return _chatCollection.where("users", arrayContains: uid).snapshots().map((event) => event.documents.map((e) => ChatModel.fromJson(e.data)).toList());
  }

  Future addMessageToChat({DocumentReference chat, ChatMsg msg}) async {
    return await chat.updateData({
      "messages": FieldValue.arrayUnion([msg.toJson()])
    });
  }

  Stream<ChatModel> chatStreamFromChat({DocumentReference chat}) {
    return chat.snapshots().map((event) => ChatModel.fromJson(event.data)).asBroadcastStream();
  }

  Future deleteChat({String uid1, String uid2}) async {
    final chat = await findChat(uid1: uid1, uid2: uid2);
    return chat?.delete();
  }

  Future deleteUserChats({String uid}) async {
    final chats = await findChats(uid: uid);
    chats.forEach((element) {
      element.delete();
    });
  }
}
