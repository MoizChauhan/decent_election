import 'package:decent_election/app/model/voters_model.dart';
import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/widgets/app_bar.dart';
import 'package:decent_election/app/widgets/app_button.dart';
import 'package:decent_election/app/widgets/app_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVoter extends StatefulWidget {
  const AddVoter({super.key});

  @override
  State<AddVoter> createState() => _AddVoterState();
}

class _AddVoterState extends State<AddVoter> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final TextEditingController privateKeyController = TextEditingController();

  final TextEditingController walletAddressController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          child: Column(
        children: [
          SimpleAppBar(title: "Voter"),
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
                controller: privateKeyController,
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
                controller: passController,
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
          if (loading) loader(),
          if (!loading)
            AppButton(
                onPressed: () {
                  createVoter();
                },
                buttonText: "Create"),
        ],
      )),
    );
  }

  Future<void> createVoter() async {
    setState(() {
      loading = true;
    });
    VotersModel votersModel = VotersModel(
      uid: "",
      privateKey: privateKeyController.text,
      email: emailController.text,
      password: passController.text,
      walletAddress: walletAddressController.text,
      currentElectionAddress: "",
      role: "2",
      electionCommisionName: '',
      electionName: '',
    );
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: votersModel.email,
        password: votersModel.password,
      );
      votersModel.uid = credential.user!.uid;
      await FirebaseService.createVoter(votersModel: votersModel);
      setState(() {
        loading = false;
      });
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
    }
  }
}
