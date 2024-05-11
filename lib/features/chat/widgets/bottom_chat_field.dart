import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const BottomChatField({super.key, required this.receiverUserId, required this.isGroupChat});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FlutterSoundRecorder? _soundRecorder;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic Permission not allowed");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    print(isRecorderInit);
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.receiverUserId, widget.isGroupChat);
      setState(() {
        _messageController.text = "";
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = "${tempDir.path}/flutter_sound.aac";
      if(!isRecorderInit) return; 
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum, widget.isGroupChat);
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

  void selectGIF() async { 
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      // ignore: use_build_context_synchronously
      ref
          .read(chatControllerProvider)
          .sendGIF(context, gif.url, widget.receiverUserId,widget.isGroupChat);
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
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Column(
        children: [
          isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
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
                      isShowSendButton ? Icons.send :isRecording?Icons.close: Icons.mic,
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