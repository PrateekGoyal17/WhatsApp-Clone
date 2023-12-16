import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  void navigatetoLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50, width: double.infinity),
            const Text(
              "Welcome to WhatsApp",
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 9),
            Image.asset(
              "assets/bg.png",
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Read our Privacy Policy. Tap \"Agree and Continue\" to accept the Terms of Service",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: CustomButton(
                  text: "Agree and Continue",
                  onPressed: () => navigatetoLoginScreen(context)),
            )
          ],
        ),
      ),
    );
  }
}
