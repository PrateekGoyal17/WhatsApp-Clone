import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList(
      {super.key, required this.recieverUserId, required this.isGroupChat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.state).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg3.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          StreamBuilder<List<Message>>(
              stream: widget.isGroupChat
                  ? ref
                      .read(chatControllerProvider)
                      .groupChatStream(widget.recieverUserId)
                  : ref
                      .read(chatControllerProvider)
                      .getMessages(widget.recieverUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  messageController
                      .jumpTo(messageController.position.maxScrollExtent);
                });
                return ListView.builder(
                  controller: messageController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    final messageData = snapshot.data![index];
                    var timeSent = DateFormat.Hm().format(messageData.timeSent);

                    if (!messageData.isSeen &&
                        messageData.receiverId ==
                            FirebaseAuth.instance.currentUser!.uid) {
                      ref.read(chatControllerProvider).setChatMessageSeen(
                          context, widget.recieverUserId, messageData.messageId);
                    } // This if is used for the seen feature.

                    if (messageData.senderId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return MyMessageCard(
                        message: messageData.text,
                        date: timeSent,
                        messageEnum: messageData.messageType,
                        repliedText: messageData.repliedMessage,
                        username: messageData.repliedTo,
                        repliedMessageType: messageData.messageType,
                        onLeftSwipe: (d) => onMessageSwipe(
                            messageData.text, true, messageData.messageType),
                        isSeen: messageData.isSeen,
                      );
                    }
                    return SenderMessageCard(
                      message: messageData.text,
                      date: timeSent,
                      messageEnum: messageData.messageType,
                      username: messageData.repliedTo,
                      repliedMessageType: messageData.messageType,
                      onRightSwipe: (d) => onMessageSwipe(
                          messageData.text, false, messageData.messageType),
                      repliedText: messageData.repliedMessage,
                    );
                  }),
                );
              }),
        ],
      ),
    );
  }
}
