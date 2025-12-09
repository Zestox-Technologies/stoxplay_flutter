// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? token;
  final User? user;

  UserModel({this.token, this.user});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(token: json["token"], user: json["user"] == null ? null : User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
  final String? id;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? roleName;
  final bool? active;
  final dynamic state;
  final dynamic area;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? walletBalance;
  final dynamic createdByAdminId;
  final String? referralCodeInputValue;
  final String? referredByBrokerId;

  User({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.roleName,
    this.active,
    this.state,
    this.area,
    this.createdAt,
    this.updatedAt,
    this.walletBalance,
    this.createdByAdminId,
    this.referralCodeInputValue,
    this.referredByBrokerId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phoneNumber: json["phoneNumber"],
    roleName: json["roleName"],
    active: json["active"],
    state: json["state"],
    area: json["area"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    walletBalance: json["walletBalance"],
    createdByAdminId: json["createdByAdminId"],
    referralCodeInputValue: json["referralCodeInputValue"],
    referredByBrokerId: json["referredByBrokerId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "roleName": roleName,
    "active": active,
    "state": state,
    "area": area,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "walletBalance": walletBalance,
    "createdByAdminId": createdByAdminId,
    "referralCodeInputValue": referralCodeInputValue,
    "referredByBrokerId": referredByBrokerId,
  };
}
