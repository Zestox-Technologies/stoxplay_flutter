import 'dart:convert';

CheckPhoneNumberModel checkPhoneNumberModelFromJson(String str) =>
    CheckPhoneNumberModel.fromJson(json.decode(str));

String checkPhoneNumberModelToJson(CheckPhoneNumberModel data) =>
    json.encode(data.toJson());

class CheckPhoneNumberModel {
  final bool? userExists;

  CheckPhoneNumberModel({this.userExists});

  factory CheckPhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      CheckPhoneNumberModel(userExists: json["userExists"]);

  Map<String, dynamic> toJson() => {"userExists": userExists};
}
