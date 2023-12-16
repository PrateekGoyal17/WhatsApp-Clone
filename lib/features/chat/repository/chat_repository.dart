import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData = await firestore
            .collection("users")
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
            name: user.name,
            lastMessage: chatContact.lastMessage,
            contactId: user.uid,
            profilePic: user.profilePic,
            timeSent: chatContact.timeSent));
      }
      return contacts;
    });
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required String senderUserName,
    required String receiverUserName,
    required String messageId,
    required DateTime timeSent,
    required MessageEnum messageType,
  }) async {
    var message = Message(
        text: text,
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        messageId: messageId,
        timeSent: timeSent,
        messageType: messageType,
        isSeen: false);
    // users -> senderUserId -> chats -> recieverUserId -> message -> messageID -> setData

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // users -> recieverUserId -> chats -> senderUserId -> message -> messageID -> setData

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void _saveDataToContactsSubcollection(
      UserModel receiverUserData,
      UserModel senderUserData,
      DateTime timeSent,
      String text,
      String receiverUserId) async {
    // users -> recieverUserId -> chats -> currentUserId -> setData

    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        lastMessage: text,
        contactId: senderUserData.uid,
        profilePic: senderUserData.profilePic,
        timeSent: timeSent);
// Here we are storing the chat to the reciver side.
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection("chats")
        .doc(senderUserData.uid)
        .set(recieverChatContact.toMap());

    // users -> currentUserId -> chats -> recieverUserId -> setData

    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        lastMessage: text,
        contactId: receiverUserId,
        profilePic: receiverUserData.profilePic,
        timeSent: timeSent);
// Here we are storing the chat to the reciver side.
    await firestore
        .collection("users")
        .doc(senderUserData.uid)
        .collection("chats")
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required UserModel senderUserData,
    required String text,
    required String receiverUserId,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          receiverUserData, senderUserData, timeSent, text, receiverUserId);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        senderUserName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
