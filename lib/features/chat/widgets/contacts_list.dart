import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/group.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<List<Group>>(
                      stream: ref.watch(chatControllerProvider).chatGroups(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Loader();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            var groupData = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context, MobileChatScreen.routeName, arguments: {
                                    'name': groupData.name,
                                    'uid':groupData.groupId
                                  }
                                );
                              }, // On tap of a single contact
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    maxRadius: 24,
                                    backgroundImage: NetworkImage(
                                      groupData.groupPic,
                                    ),
                                  ),
                                  title: Text(
                                    groupData.name,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      groupData.lastMessage,
                                      style:
                                          const TextStyle(fontSize: 15, color: Colors.grey),
                                    ),
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(groupData.timeSent),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                      StreamBuilder<List<ChatContact>>(
                      stream: ref.watch(chatControllerProvider).getChatContacts(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Loader();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            var chatContactData = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context, MobileChatScreen.routeName, arguments: {
                                    'name': chatContactData.name,
                                    'uid':chatContactData.contactId
                                  }
                                );
                              }, // On tap of a single contact
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    maxRadius: 24,
                                    backgroundImage: NetworkImage(
                                      chatContactData.profilePic,
                                    ),
                                  ),
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style:
                                          const TextStyle(fontSize: 15, color: Colors.grey),
                                    ),
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(chatContactData.timeSent),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                ],
              ),
            ),
          ),
          const Divider(
            color: dividerColor,
            indent: 85,
          )
        ],
      ),
    );
  }
}
