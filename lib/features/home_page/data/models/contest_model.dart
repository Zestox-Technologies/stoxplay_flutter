// To parse this JSON data, do
//
//     final contestModel = contestModelFromJson(jsonString);

import 'dart:convert';

ContestModel contestModelFromJson(String str) => ContestModel.fromJson(json.decode(str));

String contestModelToJson(ContestModel data) => json.encode(data.toJson());

class ContestModel {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? entryFee;
  final int? totalSpots;
  final int? spotsFilled;
  final int? teamsPerUser;
  final int? prizePool;
  final String? status;
  final String? sectorId;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalCollection;
  final int? spotsLeft;
  final int? winningChancePercentage;

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
    this.sectorId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.totalCollection,
    this.spotsLeft,
    this.winningChancePercentage,
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
    sectorId: json["sectorId"],
    createdById: json["createdById"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    totalCollection: json["totalCollection"],
    spotsLeft: json["spotsLeft"],
    winningChancePercentage: json["winningChancePercentage"],
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
    "sectorId": sectorId,
    "createdById": createdById,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "totalCollection": totalCollection,
    "spotsLeft": spotsLeft,
    "winningChancePercentage": winningChancePercentage,
  };
}
