import 'dart:ffi';

import 'package:event_scheduler_project/components/message_bubble.dart';
import 'package:event_scheduler_project/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  "https://www.w3schools.com/howto/img_avatar.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Danny hopkins"),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Sender's message
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: false),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(
                        message:
                            "eooeooeoooeooooeooeoooeooooeooeoooeooooeoooeoooo",
                        isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    MessageBubble(message: "eooo", isSender: true),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          BottomAppBar(
            color: AppColors.background,
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: 50.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        suffixIcon: Icon(Icons.send),
                        border: OutlineInputBorder(
                          // Use OutlineInputBorder
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the border radius
                          borderSide: BorderSide.none, // Remove the border
                        ),
                        filled: true,
                        fillColor: Color(0xFF3D4354),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true, // Set this to true
    );
  }
}
