// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? profilePictureUrl;
  DateTime? dateOfBirth;
  String? phoneNumber;
  String? gender;
  String? roleName;
  bool? active;
  int? walletBalance;
  dynamic state;
  dynamic area;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.profilePictureUrl,
    this.dateOfBirth,
    this.phoneNumber,
    this.gender,
    this.roleName,
    this.active,
    this.walletBalance,
    this.state,
    this.area,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    username: json["username"],
    profilePictureUrl: json["profilePictureUrl"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    phoneNumber: json["phoneNumber"],
    gender: json["gender"],
    roleName: json["roleName"],
    active: json["active"],
    walletBalance: json["walletBalance"],
    state: json["state"],
    area: json["area"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "username": username,
    "profilePictureUrl": profilePictureUrl,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "phoneNumber": phoneNumber,
    "gender": gender,
    "roleName": roleName,
    "active": active,
    "walletBalance": walletBalance,
    "state": state,
    "area": area,
  };


ProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? phoneNumber,
    String? roleName,
    bool? active,
    int? walletBalance,
    String? state,
    String? area,
    DateTime? dob,
    String? profilePictureUrl,
    String? gender,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roleName: roleName ?? this.roleName,
      active: active ?? this.active,
      walletBalance: walletBalance ?? this.walletBalance,
      state: state ?? this.state,
      area: area ?? this.area,
      dateOfBirth: dob ?? this.dateOfBirth,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      gender: gender ?? this.gender,
    );
  }
}
