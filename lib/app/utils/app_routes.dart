import 'package:decent_election/app/model/election_model.dart';
import 'package:decent_election/app/screen/election_comission/create_election.dart';
import 'package:decent_election/app/screen/election_comission/election_home_screen.dart';
import 'package:decent_election/app/screen/election_comission/my_elections.dart';
import 'package:decent_election/app/screen/election_comission/voter_list_screen.dart';
import 'package:decent_election/app/screen/login_screen.dart';
import 'package:decent_election/app/screen/voter/voter_home_screen.dart';
import 'package:decent_election/app/screen/voter/voter_profile_screen.dart';
import 'package:decent_election/app/utils/enums.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class AppRoutes {
  static navigateOffLogin() {
    Get.offAll(LoginScreen());
  }

  static navigateOffVoterHomeScreen() {
    Get.offAll(VoterHomeScreen());
  }

  static navigateToVoterProfile() {
    Get.to(VoterProfileScreen());
  }

  static navigateOffElectionHomeScreen() {
    Get.to(ElectionHomeScreen());
  }

  static navigatetoMyElection() {
    Get.to(MyElections());
  }

  static navigatetoVoterList() {
    Get.to(VoterListScreen());
  }

  static navigatetoCreateElection(
      {required ScreenOps screenOps, ElectionModel? electionModel}) {
    Get.to(CreateElection(screenOps: screenOps, electionModel: electionModel));
  }
}
