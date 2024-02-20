import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
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

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async{
    GiphyGif? gif = await pickGIF(context);
    if(gif!=null){
      // ignore: use_build_context_synchronously
      ref.read(chatControllerProvider).sendGIF(context, gif.url, widget.receiverUserId);
    }
  }

  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
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
      child: Column(
        children: [
          Row(
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
                          onPressed: toggleEmojiKeyboardContainer,
                          icon: Icon(
                            Icons.emoji_emotions,
                            size: MediaQuery.of(context).size.width * 0.075,
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.11,
                        top: 3,
                        bottom: 3,
                        child: IconButton(
                          onPressed: selectGIF,
                          icon: Icon(
                            Icons.gif,
                            size: MediaQuery.of(context).size.width * 0.075,
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width * 0.005,
                        left: MediaQuery.of(context).size.width * 0.241,
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _messageController,
                          onTap: () {
                            if (isShowEmojiContainer) {
                              hideEmojiContainer();
                            }
                          },
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width * 0.14,
                        top: 3,
                        bottom: 3,
                        child: IconButton(
                          onPressed: selectVideo,
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
                          onPressed: selectImage,
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
          isShowEmojiContainer
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: EmojiPicker(onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                )
              : const SizedBox()
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