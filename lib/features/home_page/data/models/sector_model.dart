// To parse this JSON data, do
//
//     final sectorModel = sectorModelFromJson(jsonString);

import 'dart:convert';

SectorModel sectorModelFromJson(String str) => SectorModel.fromJson(json.decode(str));

String sectorModelToJson(SectorModel data) => json.encode(data.toJson());

class SectorModel {
  final String? id;
  final String? name;
  final bool? isActive;
  final dynamic backgroundImage;
  final dynamic sectorLogo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? maxWin;
  final List<int>? joinCountDistribution;
  final int? totalJoined;

  SectorModel({
    this.id,
    this.name,
    this.isActive,
    this.backgroundImage,
    this.sectorLogo,
    this.createdAt,
    this.updatedAt,
    this.maxWin,
    this.joinCountDistribution,
    this.totalJoined,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
    id: json["id"],
    name: json["name"],
    isActive: json["isActive"],
    backgroundImage: json["backgroundImage"],
    sectorLogo: json["sectorLogo"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    maxWin: json["maxWin"],
    totalJoined: json["totalJoined"],
    joinCountDistribution: List<int>.from(json["joinCountDistribution"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isActive": isActive,
    "backgroundImage": backgroundImage,
    "sectorLogo": sectorLogo,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "maxWin": maxWin,
    "totalJoined": totalJoined,
    "joinCountDistribution": List<dynamic>.from(joinCountDistribution!.map((x) => x)),
  };
}
class SectorListResponse {
  final String nextMatchDate;
  final List<SectorModel> sectors;

  SectorListResponse({
    required this.nextMatchDate,
    required this.sectors,
  });

  factory SectorListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SectorListResponse(
      nextMatchDate: data['nextMatchDate'],
      sectors: (data['data'] as List)
          .map((e) => SectorModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": {
      "nextMatchDate": nextMatchDate,
      "data": List<dynamic>.from(sectors.map((x) => x.toJson())),
    }
  };
}

