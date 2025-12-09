// To parse this JSON data, do
//
//     final contestModel = contestModelFromJson(jsonString);

import 'dart:convert';

import 'package:stoxplay/features/stats_page/data/stats_model.dart';

ContestModel contestModelFromJson(String str) => ContestModel.fromJson(json.decode(str));

String contestModelToJson(ContestModel data) => json.encode(data.toJson());

class ContestModel {
  String? id;
  String? name;
  String? description;
  DateTime? startTime;
  DateTime? endTime;
  int? entryFee;
  int? totalSpots;
  int? spotsFilled;
  int? teamsPerUser;
  int? prizePool;
  String? status;
  bool? isRecurring;
  String? sectorId;
  String? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? prizeDistributionTemplateId;
  Sector? sector;
  CreatedBy? createdBy;
  int? totalCollection;
  int? spotsLeft;
  int? winningChancePercentage;
  int? firstPrize;
  TimeLeft? timeLeftToStart;

  ContestModel({
    this.id,
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.entryFee,
    this.totalSpots,
    this.spotsFilled,
    this.teamsPerUser,
    this.prizePool,
    this.status,
    this.isRecurring,
    this.sectorId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.prizeDistributionTemplateId,
    this.sector,
    this.createdBy,
    this.totalCollection,
    this.spotsLeft,
    this.winningChancePercentage,
    this.firstPrize,
    this.timeLeftToStart,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) => ContestModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    entryFee: json["entryFee"],
    totalSpots: json["totalSpots"],
    spotsFilled: json["spotsFilled"],
    teamsPerUser: json["teamsPerUser"],
    prizePool: json["prizePool"],
    status: json["status"],
    isRecurring: json["isRecurring"],
    sectorId: json["sectorId"],
    createdById: json["createdById"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    prizeDistributionTemplateId: json["prizeDistributionTemplateId"],
    sector: json["sector"] == null ? null : Sector.fromJson(json["sector"]),
    createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
    totalCollection: json["totalCollection"],
    spotsLeft: json["spotsLeft"],
    winningChancePercentage: json["winningChancePercentage"],
    firstPrize: json["firstPrize"],
    timeLeftToStart: json["timeLeftToStart"] == null ? null : TimeLeft.fromJson(json["timeLeftToStart"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "entryFee": entryFee,
    "totalSpots": totalSpots,
    "spotsFilled": spotsFilled,
    "teamsPerUser": teamsPerUser,
    "prizePool": prizePool,
    "status": status,
    "isRecurring": isRecurring,
    "sectorId": sectorId,
    "createdById": createdById,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "prizeDistributionTemplateId": prizeDistributionTemplateId,
    "sector": sector?.toJson(),
    "createdBy": createdBy?.toJson(),
    "totalCollection": totalCollection,
    "spotsLeft": spotsLeft,
    "winningChancePercentage": winningChancePercentage,
    "firstPrize": firstPrize,
    "timeLeftToStart": timeLeftToStart?.toJson(),
  };
}

class CreatedBy {
  String? id;
  dynamic email;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  dynamic phoneNumber;
  dynamic gender;
  dynamic profilePictureUrl;
  dynamic dateOfBirth;
  String? roleName;
  bool? active;
  dynamic state;
  dynamic area;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? walletBalance;
  dynamic createdByAdminId;
  dynamic referralCodeInputValue;
  dynamic referredByBrokerId;

  CreatedBy({
    this.id,
    this.email,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
    this.dateOfBirth,
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

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phoneNumber: json["phoneNumber"],
    gender: json["gender"],
    profilePictureUrl: json["profilePictureUrl"],
    dateOfBirth: json["dateOfBirth"],
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
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "gender": gender,
    "profilePictureUrl": profilePictureUrl,
    "dateOfBirth": dateOfBirth,
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

class Sector {
  String? id;
  String? name;
  bool? isActive;
  String? backgroundImage;
  String? sectorLogo;
  DateTime? createdAt;
  DateTime? updatedAt;

  Sector({this.id, this.name, this.isActive, this.backgroundImage, this.sectorLogo, this.createdAt, this.updatedAt});

  factory Sector.fromJson(Map<String, dynamic> json) => Sector(
    id: json["id"],
    name: json["name"],
    isActive: json["isActive"],
    backgroundImage: json["backgroundImage"],
    sectorLogo: json["sectorLogo"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isActive": isActive,
    "backgroundImage": backgroundImage,
    "sectorLogo": sectorLogo,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
