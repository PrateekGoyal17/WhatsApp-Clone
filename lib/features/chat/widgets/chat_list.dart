import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/features/chat/widgets/my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({super.key, required this.recieverUserId});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Message>>(
          stream: ref
              .read(chatControllerProvider)
              .getMessages(widget.recieverUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              messageController.jumpTo(messageController.position.maxScrollExtent);
            });
            return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                final messageData = snapshot.data![index];
                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    messageEnum: messageData.messageType,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  messageEnum: messageData.messageType,
                );
              }),
            );
          }),
    );
  }
}
