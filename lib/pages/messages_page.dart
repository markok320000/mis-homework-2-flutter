import 'package:event_scheduler_project/components/chat_card.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
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
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
          ]),
        ),
      ),
    );
  }
}
