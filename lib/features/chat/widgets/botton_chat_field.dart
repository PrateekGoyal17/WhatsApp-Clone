import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.receiverUserId);
      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                color: mobileChatBoxColor,
                borderRadius: BorderRadius.circular(30),
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.01,
                    top: 3,
                    bottom: 3,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        size: MediaQuery.of(context).size.width * 0.075,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.008,
                    left: MediaQuery.of(context).size.width * 0.125,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: TextFormField(
                      controller: _messageController,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isShowSendButton = true;
                          });
                        } else {
                          setState(() {
                            isShowSendButton = false;
                          });
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.14,
                    top: 3,
                    bottom: 3,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        size: MediaQuery.of(context).size.width * 0.075,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.02,
                    top: 3,
                    bottom: 3,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        size: MediaQuery.of(context).size.width * 0.075,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 56, 183, 122),
              maxRadius: MediaQuery.of(context).size.width * 0.065,
              child: GestureDetector(
                child: Icon(
                  isShowSendButton ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
                onTap: sendTextMessage,
              ),
            ),
          )
        ],
      ),
    );
  }
}




// Money positoned

                  // Positioned(
                  //   right: MediaQuery.of(context).size.width * 0.30,
                  //   top: 3,
                  //   bottom: 3,
                  //   child: Icon(
                  //     Icons.money,
                  //     size: MediaQuery.of(context).size.width * 0.075,
                  //     color: Colors.grey,
                  //   ),
                  // ),