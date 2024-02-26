import 'package:event_scheduler_project/components/chat_card.dart';
import 'package:event_scheduler_project/main.dart';
import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/pages/main_page.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<String> chatIds = [];

  late UserProvider _userProvider; // Declare UserProvider variable

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    getChatIds();
  }

  void getChatIds() {
    chatIds = _userProvider.user.chats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _userProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
                (route) =>
                    false, // This makes sure all previous routes are removed
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1B202D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(children: [
            ...chatIds.map((chatId) {
              return ChatCard(
                chatId: chatId,
              );
            }).toList(),
          ]),
        ),
      ),
    );
  }
}
