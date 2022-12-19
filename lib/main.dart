import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/utils/app_colors.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  // ec@decentelection.com
  WidgetsFlutterBinding.ensureInitialized();
  Pref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Decent Election',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        theme: ThemeData(
          primarySwatch: getMaterialColor(AppColors.primaryColor),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
