import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:decent_election/app/utils/enums.dart';
import 'package:decent_election/app/widgets/app_bar.dart';
import 'package:decent_election/app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class ElectionHomeScreen extends StatelessWidget {
  const ElectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
              onPressed: () {
                AppRoutes.navigatetoMyElection();
              },
              buttonText: "My Elections"),
          SizedBox(height: 15),
          AppButton(
              onPressed: () {
                AppRoutes.navigatetoVoterList();
              },
              buttonText: "Voter List"),
          SizedBox(height: 15),
          AppButton(
              onPressed: () {
                AppRoutes.navigatetoCreateElection(
                    screenOps: ScreenOps.add, electionModel: null);
              },
              buttonText: "Create Election"),
          SizedBox(height: 15),
          AppButton(
              onPressed: () {
                FirebaseService.logout();
              },
              buttonText: "Logout"),
        ],
      ),
    ));
  }
}
