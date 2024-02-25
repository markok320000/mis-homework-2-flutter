import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/pages/ChatPage.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatefulWidget {
  final String chatId;

  const ChatCard({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  ChatDTO? chat;
  late UserProvider _userProvider;
  String? chatterName;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    getChat();
  }

  void getChat() async {
    ChatDTO fetchedChat = await ApiMethods().fetchChatById(widget.chatId);

    setState(() {
      chat = fetchedChat;
      if (chat != null) {
        chatterName = chat!.firstParticipantId == _userProvider.user.username
            ? chat!.secondParticipantId
            : chat!.firstParticipantId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    chat: chat!,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://www.w3schools.com/howto/img_avatar.png"),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chatterName != null)
                      Text(
                        chatterName!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    else
                      CircularProgressIndicator(), // Display loading indicator if chatterName is null
                    Text(chatterName ??
                        "Loading..."), // Display "Loading..." if chatterName is null
                  ],
                ),
              ],
            ),
            Text("08:40"),
          ],
        ),
      ),
    );
  }
}
