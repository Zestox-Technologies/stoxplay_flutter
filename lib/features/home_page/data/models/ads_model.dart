// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  String? id;
  String? adId;
  String? type;
  String? title;
  String? description;
  String? fileUrl;
  bool? isActive;
  DateTime? startDate;
  DateTime? endDate;
  String? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  CreatedBy? createdBy;

  AdsModel({
    this.id,
    this.adId,
    this.type,
    this.title,
    this.description,
    this.fileUrl,
    this.isActive,
    this.startDate,
    this.endDate,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    id: json["id"],
    adId: json["adId"],
    type: json["type"],
    title: json["title"],
    description: json["description"],
    fileUrl: json["fileUrl"],
    isActive: json["isActive"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    createdById: json["createdById"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "adId": adId,
    "type": type,
    "title": title,
    "description": description,
    "fileUrl": fileUrl,
    "isActive": isActive,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "createdById": createdById,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "createdBy": createdBy?.toJson(),
  };
}

class CreatedBy {
  String? id;
  String? username;

  CreatedBy({
    this.id,
    this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
