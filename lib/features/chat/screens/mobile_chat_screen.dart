import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/botton_chat_field.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = "/mobile-chat-screen";
  final String name;
  final String uid;
  const MobileChatScreen({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userData(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          // Chat List
          const Expanded(child: ChatList()),
          // Text Input Field
          BottomChatField(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}



// TextField(
//             decoration: InputDecoration(
//               hintText: "Message",
//               filled: true,
//               fillColor: mobileChatBoxColor,
//               prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: IconButton(
//                       onPressed: () {}, icon: Icon(Icons.emoji_emotions))),
//               suffixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                         onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
//                     IconButton(
//                         onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
//                     IconButton(
//                         onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
//                   ],
//                 ),
//               ),
//             ),
//           )