import 'package:decent_election/app/service/contract_linking.dart';
import 'package:decent_election/app/utils/app_assets.dart';
import 'package:decent_election/app/utils/app_colors.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ContractLinking.init();
    Future.delayed(Duration(seconds: 2), () {
      if (getPrefValue(Keys.AUTH_TOKEN) != "") {
        if (getPrefValue(Keys.ROLE) == "1") {
          AppRoutes.navigateOffElectionHomeScreen();
        } else {
          AppRoutes.navigateOffVoterHomeScreen();
        }
      } else {
        AppRoutes.navigateOffLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      AppAssets.appLogo,
                      width: 150,
                    ),
                  ),
                  // SizedBox(),
                  // Text(
                  //   "Local Menu",
                  //   style: TextStyle(
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 15,

                  //     fontWeight: FontWeight.w800,
                  //     color: const Color(0xff6B6B6B),
                  //   ),
                  //   // #6B6B6B
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            gradient: LinearGradient(
              begin: Alignment(-0.35, -1.272),
              end: Alignment(0.84, 0.87),
              colors: [
                AppColors.gradient1,
                AppColors.white,
                AppColors.white,
                AppColors.white,
                AppColors.gradient2
              ],
              stops: const [0.0, 0.28, 0.50, 0.90, 1.0],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
