import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/chat_model.dart';
import 'package:YoNunca/src/models/chat_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final DocumentReference chat;
  ChatPage({Key key, @required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String msg = "";
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final bloc = AppStateContainer.of(context).blocProvider;
    final user = bloc.appUserBloc.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          children: [
            Expanded(child: _createChatMsgs(context)),
            Container(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) => msg = value,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (msg.length > 0) {
                          final chatMsg = ChatMsg(msg: msg, timeStamp: DateTime.now(), uid: user.userData.uid);
                          bloc.chatBloc.addMessageToChat(chat: chat, msg: chatMsg);
                          _controller.clear();
                        }
                      },
                      icon: Icon(Icons.send),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _createChatMsgs(BuildContext context) {
    final chat = widget.chat;
    final bloc = AppStateContainer.of(context).blocProvider;
    final user = bloc.appUserBloc.currentUser;

    return Container(
      padding: EdgeInsets.all(20),
      color: Color.fromRGBO(100, 100, 100, 1),
      child: StreamBuilder(
        stream: bloc.chatBloc.chatStreamFromChat(chat: chat),
        builder: (context, AsyncSnapshot<ChatModel> snapshot) {
          if (snapshot.hasData) {
            final chatModel = snapshot.data;
            final messages = chatModel.messages;
            messages.sort((msg1, msg2) {
              return msg2.timeStamp.compareTo(msg1.timeStamp);
            });

            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.uid == user.userData.uid;
                return Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                        color: isMe ? Color.fromRGBO(110, 150, 110, 1) : Color.fromRGBO(140, 140, 140, 1),
                      ),
                      margin: EdgeInsets.all(1),
                      padding: EdgeInsets.all(5),
                      child: Text(msg.msg, style: TextStyle(fontSize: 18)),
                    )
                  ],
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
