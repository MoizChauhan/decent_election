// To parse this JSON data, do
//
//     final ecModel = ecModelFromJson(jsonString);

import 'dart:convert';

EcModel ecModelFromJson(String str) => EcModel.fromJson(json.decode(str));

String ecModelToJson(EcModel data) => json.encode(data.toJson());

class EcModel {
  EcModel({
    required this.ecName,
    required this.privateKey,
    required this.uid,
    required this.walletAddress,
  });

  String ecName;
  String privateKey;
  String uid;
  String walletAddress;

  factory EcModel.fromJson(Map<String, dynamic> json) => EcModel(
        ecName: json["ecName"],
        privateKey: json["privateKey"],
        uid: json["uid"],
        walletAddress: json["walletAddress"],
      );

  Map<String, dynamic> toJson() => {
        "ecName": ecName,
        "privateKey": privateKey,
        "uid": uid,
        "walletAddress": walletAddress,
      };
}
