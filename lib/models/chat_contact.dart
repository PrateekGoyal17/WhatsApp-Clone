class ChatContact {
  final String name;
  final String lastMessage;
  final String contactId;
  final String profilePic;
  final DateTime timeSent;

  ChatContact(
      {required this.name,
      required this.lastMessage,
      required this.contactId,
      required this.profilePic,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'contactId': contactId,
      'profilePic': profilePic,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      contactId: map['contactId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
