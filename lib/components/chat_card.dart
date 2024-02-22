import 'package:event_scheduler_project/pages/ChatPage.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: const Row(
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      "contactName",
                      style: TextStyle(
                          fontWeight: FontWeight.bold), // Make text bold
                    ),
                    Text("lastMessage"),
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
