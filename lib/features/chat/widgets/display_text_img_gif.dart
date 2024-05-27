import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(fontSize: 16),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: BoxConstraints(minWidth: 100),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(
                          () {
                            isPlaying = false;
                          },
                        );
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(
                          () {
                            isPlaying = true;
                          },
                        );
                      }
                    },
                    icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle));
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? CachedNetworkImage(imageUrl: message)
                    : type == MessageEnum.file
                        ? InkWell(
                            onTap: () async {
                              // if(await canLaunchUrl(Uri.parse(message))){
                                await launchUrl(Uri.parse(message));
                              // } else{
                                // ignore: use_build_context_synchronously
                              //   showSnackBar(context, "Couldn't download the url");
                              // }
                            //  Directory dir = Directory('/storage/emulated/0/Download');
                            //   await FlutterDownloader.enqueue(
                            //     url: message,
                            //     savedDir: dir.path,
                            //     showNotification:
                            //         true, // show download progress in status bar (for Android)
                            //     openFileFromNotification:
                            //         true, // click on notification to open downloaded file (for Android)
                            //   );
                            },
                            child: Container(
                              // color: Colors.grey,
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "📁 Download File",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : CachedNetworkImage(imageUrl: message);
  }
}
