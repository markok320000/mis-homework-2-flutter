class MessageDTO {
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime dateTime;
  String chatId = "";

  // Constructor
  MessageDTO(
      {required this.senderId,
      required this.receiverId,
      required this.messageText,
      required this.dateTime,
      this.chatId = "undefined"});

  // Factory method to deserialize JSON
  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'dateTime': dateTime.toIso8601String(),
        'messageText': messageText,
        'chatId': chatId
      };
}
