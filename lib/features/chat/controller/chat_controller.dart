import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getMessages(String recieverUserId) {
    return chatRepository.getMessages(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (senderUserData) => chatRepository.sendTextMessage(
              context: context,
              senderUserData: senderUserData!,
              text: text,
              receiverUserId: receiverUserId,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (senderUserData) => chatRepository.sendFileMessage(
              context: context,
              senderUserData: senderUserData!,
              file: file,
              recieverUserId: receiverUserId,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIF(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    //https://i.giphy.com/media/
    int gifUrlPartIndex = gifUrl.lastIndexOf("-") + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = "https://i.giphy.com/media/$gifUrlPart/200.gif";
    ref.read(userDataAuthProvider).whenData(
          (senderUserData) => chatRepository.sendGIF(
              context: context,
              senderUserData: senderUserData!,
              gifUrl: newGifUrl,
              receiverUserId: receiverUserId,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }
}
