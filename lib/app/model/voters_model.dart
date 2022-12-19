// To parse this JSON data, do
//
//     final votersModel = votersModelFromJson(jsonString);

import 'dart:convert';

VotersModel votersModelFromJson(String str) =>
    VotersModel.fromJson(json.decode(str));

String votersModelToJson(VotersModel data) => json.encode(data.toJson());

class VotersModel {
  VotersModel({
    required this.uid,
    required this.privateKey,
    required this.email,
    required this.password,
    required this.walletAddress,
    required this.role,
    required this.currentElectionAddress,
    required this.electionName,
    required this.electionCommisionName,
  });

  String uid;
  String privateKey;
  String email;
  String password;
  String walletAddress;
  String currentElectionAddress;
  String electionName;
  String electionCommisionName;
  String role;

  factory VotersModel.fromJson(Map<String, dynamic> json) => VotersModel(
        uid: json["uid"],
        privateKey: json["private_key"],
        email: json["email"],
        password: json["password"],
        walletAddress: json["wallet_address"],
        currentElectionAddress: json["currentElectionAddress"],
        role: json["role"],
        electionCommisionName: json["electionCommisionName"] ?? "",
        electionName: json["electionName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "private_key": privateKey,
        "email": email,
        "password": password,
        "wallet_address": walletAddress,
        "currentElectionAddress": currentElectionAddress,
        "electionName": electionName,
        "electionCommisionName": electionCommisionName,
        "role": role,
      };
}
