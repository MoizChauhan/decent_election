import 'dart:ui';

import 'package:decent_election/app/model/ec_model.dart';
import 'package:decent_election/app/model/voters_model.dart';
import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/utils/app_assets.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:decent_election/app/utils/app_toast.dart';
import 'package:decent_election/app/utils/constants.dart';
import 'package:decent_election/app/widgets/app_button.dart';
import 'package:decent_election/app/widgets/app_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();
  Client? httpClient;
  Web3Client? ethClient;
  bool loading = false;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(crypt_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
          child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(height: Get.height * .037),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  AppAssets.appLogo,
                  width: 150,
                ),
              ),
              SizedBox(height: Get.height * .1),
              Text(
                'Welcome To Decent Voting',
                style: TextStyle(
                  fontSize: 25,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
                softWrap: false,
              ),
              SizedBox(height: 10),
              Text(
                'Log in into your account',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xa8000000),
                ),
                softWrap: false,
              ),
              SizedBox(height: Get.height * .05),
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
                    controller: passController,
                    obscure: true,
                    keyboardType: TextInputType.visiblePassword,
                    lableText: "Password",
                  ),
                ),
              ),
              SizedBox(height: Get.height * .04),
              if (loading) Center(child: CupertinoActivityIndicator()),
              if (!loading)
                AppButton(
                    onPressed: () {
                      signIn();
                      // AppRoutes.navigateOffVoterHomeScreen();
                      // AppRoutes.navigateOffElectionHomeScreen();
                    },
                    buttonText: "Log in"),
              SizedBox(height: Get.height * .02),
            ],
          ),
        ),
      )),
    );
  }

  void signIn() async {
    try {
      setState(() {
        loading = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
      // credential.user!.uid;
      if (await FirebaseService.userExists(credential.user!.uid)) {
        setPrefValue(Keys.AUTH_TOKEN, credential.user!.uid);
        if (await FirebaseService.getRole(credential.user!.uid) == "1") {
          setPrefValue(Keys.ROLE, "1");
          EcModel? ecModel =
              await FirebaseService.getECModel(credential.user!.uid);
          if (ecModel != null) {
            setPrefValue(Keys.ECNAME, ecModel.ecName);
          } else {
            setPrefValue(Keys.CONTRACT, "");
            longToastMessage("User Not registered");

            FirebaseService.logout();
          }
          setState(() {
            loading = false;
          });
          AppRoutes.navigateOffElectionHomeScreen();
        } else {
          setPrefValue(Keys.ROLE, "2");
          VotersModel? votersModel =
              await FirebaseService.getVoterModel(credential.user!.uid);
          if (votersModel != null) {
            setPrefValue(Keys.CONTRACT, votersModel.currentElectionAddress);
            setPrefValue(Keys.USERNAME, votersModel.email);
            setPrefValue(Keys.PRIVATEKEY, votersModel.privateKey);
            setPrefValue(Keys.WALLETADDRESS, votersModel.walletAddress);
            setPrefValue(Keys.ELNAME, votersModel.electionName);
            setPrefValue(Keys.ECNAME, votersModel.electionCommisionName);
          } else {
            setPrefValue(Keys.CONTRACT, "");
            longToastMessage("User Not registered");

            FirebaseService.logout();
          }
          setState(() {
            loading = false;
          });
          AppRoutes.navigateOffVoterHomeScreen();
        }
      } else {
        longToastMessage("User Not registered");
        setState(() {
          loading = false;
        });
        AppRoutes.navigateOffLogin();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        longToastMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        longToastMessage('Wrong password provided for that user.');
      }
      setState(() {
        loading = false;
      });
    }
  }
}
