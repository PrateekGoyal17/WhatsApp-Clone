import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
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

  Stream<List<Message>> getMessages(String recieverUserId) {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(recieverUserId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

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
    required MessageReply? messageReply,
    // here in this I haven't added extra username and recieverUsername because it was already there (if needed 7:00:00)
  }) async {
    var message = Message(
      text: text,
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      messageId: messageId,
      timeSent: timeSent,
      messageType: messageType,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUserName,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
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
    required MessageReply? messageReply,
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
        messageReply: messageReply,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );

      UserModel? recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactsSubcollection(
        recieverUserData,
        senderUserData,
        timeSent,
        contactMsg,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: recieverUserId,
        text: imageUrl,
        senderUserName: senderUserData.name,
        receiverUserName: recieverUserData.name,
        messageId: messageId,
        timeSent: timeSent,
        messageType: messageEnum,
        messageReply: messageReply,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sendGIF({
    required BuildContext context,
    required UserModel senderUserData,
    required String gifUrl,
    required String receiverUserId,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          receiverUserData, senderUserData, timeSent, 'GIF', receiverUserId);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        senderUserName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        messageReply: messageReply,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
