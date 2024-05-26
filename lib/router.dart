import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/error_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/user_profile_screen.dart';
import 'package:whatsapp_clone/features/group/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final String verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final String name = arguments['name'];
      final String uid = arguments['uid'];
      final bool isGroupChat = arguments['isGroupChat'];
      final String profilePic = arguments['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(name: name,uid: uid, isGroupChat: isGroupChat,profilePic: profilePic,));
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(file: file));
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
      case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );
      case UserProfileScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final String name = arguments['name'];
      final String profilePic = arguments['profilePic'];
      // final String phoneNo = arguments['phoneNo'];
      return MaterialPageRoute(
          builder: (context) => UserProfileScreen(name: name, profilePic: profilePic,));
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "This Page doesn't exist"),
              ));
  }
}
