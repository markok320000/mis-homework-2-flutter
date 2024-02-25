import 'package:event_scheduler_project/models/message.dart';

class ChatDTO {
  final String id;
  final List<MessageDTO> messages;
  final String firstParticipantId;
  final String secondParticipantId;

  // Constructor
  ChatDTO({
    required this.id,
    required this.messages,
    required this.firstParticipantId,
    required this.secondParticipantId,
  });

  // Factory method to deserialize JSON
  factory ChatDTO.fromJson(Map<String, dynamic> json) {
    List<MessageDTO> messages = [];
    if (json['messages'] != null) {
      messages = List<MessageDTO>.from(json['messages']
          .map((messageJson) => MessageDTO.fromJson(messageJson)));
    }
    return ChatDTO(
      id: json['id'],
      messages: messages,
      firstParticipantId: json['firstParticipantId'],
      secondParticipantId: json['secondParticipantId'],
    );
  }
}
