import 'package:whatsapp_clone/common/enums/message_enum.dart';

class Message {
  final String text;
  final String senderId;
  final String receiverId;
  final String messageId;
  final DateTime timeSent;
  final MessageEnum messageType;
  final bool isSeen;

  Message(
      {required this.text,
      required this.senderId,
      required this.receiverId,
      required this.messageId,
      required this.timeSent,
      required this.messageType,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageType': messageType.type,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text']?? '',
      senderId: map['senderId']?? '',
      receiverId: map['receiverId']?? '',
      messageId: map['messageId']?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageType: (map['messageType'] as String).toEnum(),
      isSeen: map['isSeen']?? false,
    );
  }
}
