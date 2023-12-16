import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        countryListTheme: CountryListThemeData(
            backgroundColor: backgroundColor,
            bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
            textStyle: const TextStyle(fontSize: 18),
            flagSize: 25),
        showPhoneCode: true,
        useSafeArea: true,
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber(){
    String phoneNumber = phoneController.text.trim();   // Trimed because if user enters space then it will give error.
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else{
      showSnackBar(context, 'Wrong Format!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("WhatsApp will need to verify your phone number."),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: pickCountry,
                  child: Text("Pick Country"),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (country != null) Text("+ ${country!.phoneCode}"),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: "phone number",
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.60),
                SizedBox(
                  width: 90,
                  child: CustomButton(text: "NEXT", onPressed: sendPhoneNumber),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
