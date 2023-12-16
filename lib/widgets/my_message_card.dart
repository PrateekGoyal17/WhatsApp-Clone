import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  const MyMessageCard({super.key, required this.date, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
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
            padding: const EdgeInsets.only(top: 3,left: 3),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 3,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style:
                            const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.check,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
