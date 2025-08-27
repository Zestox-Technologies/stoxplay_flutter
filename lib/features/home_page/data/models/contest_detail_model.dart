// To parse this JSON data, do
//
//     final contestDetailModel = contestDetailModelFromJson(jsonString);

import 'dart:convert';

ContestDetailModel contestDetailModelFromJson(String str) => ContestDetailModel.fromJson(json.decode(str));

String contestDetailModelToJson(ContestDetailModel data) => json.encode(data.toJson());

class ContestDetailModel {
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
  List<PrizeSlab>? prizeSlabs;
  PrizeDistributionTemplate? prizeDistributionTemplate;
  int? totalCollection;

  ContestDetailModel({
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
    this.prizeSlabs,
    this.prizeDistributionTemplate,
    this.totalCollection,
  });

  factory ContestDetailModel.fromJson(Map<String, dynamic> json) => ContestDetailModel(
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
    prizeSlabs: json["prizeSlabs"] == null ? [] : List<PrizeSlab>.from(json["prizeSlabs"]!.map((x) => PrizeSlab.fromJson(x))),
    prizeDistributionTemplate: json["prizeDistributionTemplate"] == null ? null : PrizeDistributionTemplate.fromJson(json["prizeDistributionTemplate"]),
    totalCollection: json["totalCollection"],
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
    "prizeSlabs": prizeSlabs == null ? [] : List<dynamic>.from(prizeSlabs!.map((x) => x.toJson())),
    "prizeDistributionTemplate": prizeDistributionTemplate?.toJson(),
    "totalCollection": totalCollection,
  };
}

class PrizeDistributionTemplate {
  String? id;
  String? name;
  int? entryFee;
  double? guaranteedPrizeThreshold;
  int? totalSpots;
  int? prizePool;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Slab>? slabs;

  PrizeDistributionTemplate({
    this.id,
    this.name,
    this.entryFee,
    this.guaranteedPrizeThreshold,
    this.totalSpots,
    this.prizePool,
    this.createdAt,
    this.updatedAt,
    this.slabs,
  });

  factory PrizeDistributionTemplate.fromJson(Map<String, dynamic> json) => PrizeDistributionTemplate(
    id: json["id"],
    name: json["name"],
    entryFee: json["entryFee"],
    guaranteedPrizeThreshold: json["guaranteedPrizeThreshold"]?.toDouble(),
    totalSpots: json["totalSpots"],
    prizePool: json["prizePool"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    slabs: json["slabs"] == null ? [] : List<Slab>.from(json["slabs"]!.map((x) => Slab.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "entryFee": entryFee,
    "guaranteedPrizeThreshold": guaranteedPrizeThreshold,
    "totalSpots": totalSpots,
    "prizePool": prizePool,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "slabs": slabs == null ? [] : List<dynamic>.from(slabs!.map((x) => x.toJson())),
  };
}

class Slab {
  String? id;
  int? rankStart;
  int? rankEnd;
  int? prizeAmount;
  String? type;
  String? templateId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Slab({
    this.id,
    this.rankStart,
    this.rankEnd,
    this.prizeAmount,
    this.type,
    this.templateId,
    this.createdAt,
    this.updatedAt,
  });

  factory Slab.fromJson(Map<String, dynamic> json) => Slab(
    id: json["id"],
    rankStart: json["rankStart"],
    rankEnd: json["rankEnd"],
    prizeAmount: json["prizeAmount"],
    type: json["type"],
    templateId: json["templateId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rankStart": rankStart,
    "rankEnd": rankEnd,
    "prizeAmount": prizeAmount,
    "type": type,
    "templateId": templateId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}


class PrizeSlab {
  String? id;
  String? contestId;
  int? rankStart;
  int? rankEnd;
  double? percentage;
  DateTime? createdAt;
  DateTime? updatedAt;

  PrizeSlab({
    this.id,
    this.contestId,
    this.rankStart,
    this.rankEnd,
    this.percentage,
    this.createdAt,
    this.updatedAt,
  });

  factory PrizeSlab.fromJson(Map<String, dynamic> json) => PrizeSlab(
    id: json["id"],
    contestId: json["contestId"],
    rankStart: json["rankStart"],
    rankEnd: json["rankEnd"],
    percentage: json["percentage"]?.toDouble(),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contestId": contestId,
    "rankStart": rankStart,
    "rankEnd": rankEnd,
    "percentage": percentage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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

  Sector({
    this.id,
    this.name,
    this.isActive,
    this.backgroundImage,
    this.sectorLogo,
    this.createdAt,
    this.updatedAt,
  });

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
