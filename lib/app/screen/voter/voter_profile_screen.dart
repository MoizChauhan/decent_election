import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:decent_election/app/widgets/app_bar.dart';
import 'package:decent_election/app/widgets/app_button.dart';
import 'package:decent_election/app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoterProfileScreen extends StatelessWidget {
  VoterProfileScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController privateKeyController = TextEditingController();
  final TextEditingController walletAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          children: [
            SimpleAppBar(title: "Profile"),
            SizedBox(height: Get.height * .1),
            SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: AppTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  lableText: "Email",
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: AppTextField(
                  controller: emailController,
                  obscure: true,
                  keyboardType: TextInputType.visiblePassword,
                  lableText: "Private Key",
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: AppTextField(
                  controller: emailController,
                  obscure: true,
                  keyboardType: TextInputType.visiblePassword,
                  lableText: "Password",
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: AppTextField(
                  controller: walletAddressController,
                  keyboardType: TextInputType.visiblePassword,
                  lableText: "Wallet Address",
                ),
              ),
            ),
            SizedBox(height: Get.height * .04),
            AppButton(
                onPressed: () {
                  Get.back();
                },
                buttonText: "Update Profile"),
            AppButton(
                onPressed: () {
                  FirebaseService.logout();
                },
                buttonText: "Log Out"),
            SizedBox(height: Get.height * .04),
            SizedBox(height: Get.height * .02),
          ],
        ),
      ),
    );
  }
}
