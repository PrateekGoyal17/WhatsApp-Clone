import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = "/user-profile-screen";
  final String name;
  final String profilePic;
  // final String phoneNo;
  const UserProfileScreen({
    super.key,
    required this.name,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()=> Navigator.pop(context),
            icon: Icon(Icons.navigate_before_sharp),iconSize: 30,),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Stack(children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(profilePic),
                ),
              ]),
              SizedBox(
                height: 22,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 16,
              ),
              // Text(
              //   phoneNo, style: TextStyle(fontSize: 16, color: Colors.grey),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
