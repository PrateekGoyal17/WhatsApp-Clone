import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_img_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final void Function(DragUpdateDetails)? onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard(
      {super.key,
      required this.date,
      required this.message,
      required this.messageEnum,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen});

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: MediaQuery.of(context).size.width *0.3,
          ),
          child: Card(
            color: messageColor,
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(1),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: Stack(
                children: [
                  Padding(
                    padding: messageEnum == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      children: [
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),
                            child: DisplayTextImageGIF(
                              message: repliedText,
                              type: repliedMessageType,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                        DisplayTextImageGIF(
                            message: message, type: messageEnum),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 3,
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 18,
                          color: isSeen ? Colors.blue : Colors.white60,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
