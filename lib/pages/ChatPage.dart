import 'dart:convert';
import 'dart:ffi';

import 'package:event_scheduler_project/components/message_bubble.dart';
import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/models/message.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/styles/app_colors.dart';
import 'package:event_scheduler_project/utils/ChatService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatPage extends StatefulWidget {
  final ChatDTO chat;
  const ChatPage({Key? key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageDTO> messages = [];
  late UserProvider _userProvider;
  late ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _chatService = ChatService(widget.chat.id, addMessage);
    _chatService.stompClient.activate();
    messages = widget.chat.messages;
  }

  void addMessage(MessageDTO message) {
    setState(() {
      messages.add(message);
    });
  }

  void sendMessage() {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final messageDTO = MessageDTO(
        senderId: _userProvider.user.username,
        receiverId: widget.chat.secondParticipantId,
        dateTime: DateTime.now(),
        // Fill in the fields of MessageDTO
        messageText: messageText,
        chatId: widget.chat.id,
        // Other fields...
      );
      _chatService.sendMessage(messageDTO);
      _messageController.clear();
    }
  }

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
            Text(widget.chat.firstParticipantId == _userProvider.user.username
                ? widget.chat.secondParticipantId
                : widget.chat.firstParticipantId),
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
                    widget.chat.messages.length > 0
                        ? Column(
                            children: widget.chat.messages
                                .map((message) => MessageBubble(
                                    message: message.messageText,
                                    isSender: message.senderId ==
                                        _userProvider.user.username))
                                .toList(),
                          )
                        : SizedBox(),
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
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        suffixIcon: GestureDetector(
                          onTap: sendMessage,
                          child: Icon(Icons.send),
                        ),
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
