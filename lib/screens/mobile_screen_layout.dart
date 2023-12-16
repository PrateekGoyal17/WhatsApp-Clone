import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          title: const Text(
            "WhatsApp",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(10),
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            indicatorWeight: 4,
            indicatorColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelColor: tabColor,
            tabs: [
              Text("Chats"),
              Text("Updates"),
              Text("Calls"),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactScreen.routeName);
          },
          backgroundColor: tabColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.comment),
        ),
      ),
    );
  }
}
