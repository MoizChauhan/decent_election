// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decent_election/app/model/ec_model.dart';
import 'package:decent_election/app/model/election_model.dart';
import 'package:decent_election/app/model/voters_model.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String VOTER_DB = "voter";
  static String USER_DB = "users";
  static String EC_DB = "election_commision";
  static String ELECTION_DB = "myelections";
  static Future<bool> userExists(userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USER_DB)
        .where('id', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot<Object?>> documents = result.docs;
    if (documents.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getRole(userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USER_DB)
        .where('id', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot<Object?>> documents = result.docs;
    if (documents.isNotEmpty) {
      print(documents[0].data());

      return documents[0].get("role");
    } else {
      return "";
    }
  }

  static Future<VotersModel?> getVoterModel(userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(VOTER_DB)
        .where('uid', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot<Object?>> documents = result.docs;
    print(result.docs);
    if (documents.isNotEmpty) {
      print(documents[0].data());

      return votersModelFromJson(jsonEncode(documents[0].data()));
    } else {
      return null;
    }
  }

  static Future<EcModel?> getECModel(userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(EC_DB)
        .where('uid', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot<Object?>> documents = result.docs;
    print(result.docs);
    if (documents.isNotEmpty) {
      print(documents[0].data());

      return ecModelFromJson(jsonEncode(documents[0].data()));
    } else {
      return null;
    }
  }

  //Role 1> EC 2> Voter
  static Future<void> createVoter({required VotersModel votersModel}) async {
    await FirebaseFirestore.instance
        .collection(VOTER_DB)
        .doc(votersModel.uid)
        .set(votersModel.toJson());
    await FirebaseFirestore.instance
        .collection(USER_DB)
        .doc(votersModel.uid)
        .set({"id": votersModel.uid, "role": "2"});
  }

  static Future<void> createElection(
      {required ElectionModel electionModel}) async {
    await FirebaseFirestore.instance
        .collection(EC_DB)
        .doc(getPrefValue(Keys.AUTH_TOKEN))
        .collection(ELECTION_DB)
        .doc(electionModel.uid)
        .set(electionModel.toJson());
  }

  static Future<void> removeVoterInElection({
    required electionId,
    required voter,
  }) async {
    await FirebaseFirestore.instance
        .collection(EC_DB)
        .doc(getPrefValue(Keys.AUTH_TOKEN))
        .collection(ELECTION_DB)
        .doc(electionId)
        .update({
      "voters": FieldValue.arrayRemove([voter])
    });
    await FirebaseFirestore.instance.collection(VOTER_DB).doc(voter).update({
      "currentElectionAddress": "",
      "electionCommisionName": "",
      "electionName": "",
    });
  }

  static Future<List> getVotersListInElection({
    required electionId,
  }) async {
    List vo = [];
    try {
      await FirebaseFirestore.instance
          .collection(EC_DB)
          .doc(getPrefValue(Keys.AUTH_TOKEN))
          .collection(ELECTION_DB)
          .doc(electionId)
          .get()
          .then((value) {
        print(value.get("voters"));
        vo = value.get("voters");
      });
    } catch (e) {
      print(e);
      vo = [];
    }
    return vo;
  }

  static Future<void> addVoterInElection({
    required electionId,
    required voter,
    required contractAddress,
    required electionCommision,
    required electionName,
  }) async {
    await FirebaseFirestore.instance
        .collection(EC_DB)
        .doc(getPrefValue(Keys.AUTH_TOKEN))
        .collection(ELECTION_DB)
        .doc(electionId)
        .update({
      "voters": FieldValue.arrayUnion([voter])
    });
    await FirebaseFirestore.instance.collection(VOTER_DB).doc(voter).update({
      "currentElectionAddress": "$contractAddress",
      "electionCommisionName": electionCommision,
      "electionName": electionName,
    });
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await setPrefValue(Keys.AUTH_TOKEN, "");
    await setPrefValue(Keys.ROLE, "");
    await setPrefValue(Keys.CONTRACT, "");
    await setPrefValue(Keys.PRIVATEKEY, "");
    await setPrefValue(Keys.WALLETADDRESS, "");
    await setPrefValue(Keys.USERNAME, "");
    await setPrefValue(Keys.ECNAME, "");
    await setPrefValue(Keys.ELNAME, "");
    await setPrefValue(Keys.VOTED, "");

    AppRoutes.navigateOffLogin();
  }
}
