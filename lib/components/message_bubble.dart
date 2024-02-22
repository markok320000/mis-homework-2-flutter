import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomLeft: isSender ? Radius.circular(12.0) : Radius.zero,
              bottomRight: isSender ? Radius.zero : Radius.circular(12.0),
            ),
          ),
          child: ConstrainedBox(
            // Wrap the Text widget in a ConstrainedBox
            constraints: BoxConstraints(
              maxWidth: 200.0, // Set the maximum width to 200px
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
