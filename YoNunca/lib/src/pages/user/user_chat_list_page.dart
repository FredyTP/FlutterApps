import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/bloc_provider.dart';
import 'package:YoNunca/src/models/chat_model.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:YoNunca/src/pages/friends/chat_page.dart';
import 'package:flutter/material.dart';

class UserChatList extends StatelessWidget {
  const UserChatList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final user = bloc.appUserBloc.currentUser.userData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: bloc.chatBloc.getUserChatsStream(uid: user.uid),
          builder: (context, AsyncSnapshot<List<ChatModel>> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final list = snapshot.data;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final chat = list[index];
                  final friendUid = chat.users[0] == user.uid ? chat.users[1] : chat.users[0];

                  return FutureBuilder(
                    future: bloc.appUserBloc.getUserDataFromUID(friendUid),
                    builder: (context, snapshot) {
                      final friendData = snapshot.data;
                      final lastMessage = chat.messages[chat.messages.length - 1];
                      return ListTile(
                        title: snapshot.hasData ? Text(friendData.userName) : LinearProgressIndicator(),
                        subtitle: Text((lastMessage.uid == user.uid ? "-> " : "") + lastMessage.msg),
                        leading: FlutterLogo(size: 40, colors: Colors.green),
                        trailing: Text(formatTime(lastMessage.timeStamp)),
                        onTap: () => openChat(context, bloc, user.uid, friendUid),
                        onLongPress: () => _popUpMenuDestroyer(context, chat, friendData.userName),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future openChat(BuildContext context, BlocProvider bloc, String userUid, String friendUid) async {
    var chatRef = await bloc.chatBloc.findChat(uid1: userUid, uid2: friendUid);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          chat: chatRef,
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inHours < 24) {
      return time.hour.toString() + " : " + time.minute.toString();
    } else if (diff.inDays < 2) {
      return "Ayer";
    } else {
      return "Hace ${diff.inDays} dias";
    }
  }

  _popUpMenuDestroyer(BuildContext context, ChatModel chat, String chatName) async {
    final bloc = AppStateContainer.of(context).blocProvider.chatBloc;
    final popUpMenu = AlertDialog(
      title: Text("Borrar Chat"),
      content: Text("Desea Eliminar el chat de $chatName"),
      actions: [
        FlatButton.icon(
          onPressed: () {
            bloc.deleteChat(uid1: chat.users[0], uid2: chat.users[1]);
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.delete),
          label: Text("Eliminar"),
          color: Colors.red,
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 20,
    );
    showDialog(
      context: context,
      builder: (context) {
        return popUpMenu;
      },
    );
  }
}
