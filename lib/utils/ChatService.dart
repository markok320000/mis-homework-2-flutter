import 'dart:convert';

import 'package:event_scheduler_project/models/message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  final String chatId;
  late final StompClient stompClient;
  late final Function(MessageDTO) addMessage;

  ChatService(this.chatId, Function(MessageDTO) addMessageFunction) {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.0.11:8080/ws',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );

    addMessage = addMessageFunction;
  }

  void onConnect(StompFrame frame) {
    print("CONNECTED");
    stompClient.subscribe(
        destination: '/user/$chatId/private', callback: onMessageReceived);
  }

  void onMessageReceived(StompFrame payload) {
    print("message recieved");
    if (payload.body == null) return;

    addMessage(MessageDTO.fromJson(jsonDecode(payload.body!)));
    print(payload.body);
  }

  void sendMessage(MessageDTO messageDTO) {
    stompClient.send(
      destination: "/api/chat/send-message",
      body: jsonEncode(messageDTO.toJson()),
      headers: {},
    );
  }
}
