// To parse this JSON data, do
//
//     final electionModel = electionModelFromJson(jsonString);

import 'dart:convert';

ElectionModel electionModelFromJson(String str) =>
    ElectionModel.fromJson(json.decode(str));

String electionModelToJson(ElectionModel data) => json.encode(data.toJson());

class ElectionModel {
  ElectionModel({
    required this.electionName,
    required this.electionStatus,
    required this.uid,
    required this.contractAddress,
    required this.voters,
  });

  String electionName;
  String electionStatus;
  String uid;
  String contractAddress;
  List<String> voters;

  factory ElectionModel.fromJson(Map<String, dynamic> json) => ElectionModel(
        electionName: json["electionName"],
        electionStatus: json["electionStatus"],
        uid: json["uid"],
        contractAddress: json["contractAddress"],
        voters: List<String>.from(json["voters"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "electionName": electionName,
        "electionStatus": electionStatus,
        "uid": uid,
        "contractAddress": contractAddress,
        "voters": List<dynamic>.from(voters.map((x) => x)),
      };
}
