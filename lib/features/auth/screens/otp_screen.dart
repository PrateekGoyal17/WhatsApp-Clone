import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = "/otp-screen";
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20, width: double.infinity),
          const Text('We have send an SMS with a code.'),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.09),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1),
                hintText: '- - - - - -',
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  verifyOTP(ref, context, val.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
