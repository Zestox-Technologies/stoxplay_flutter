// To parse this JSON data, do
//
//     final learningModel = learningModelFromJson(jsonString);

import 'dart:convert';

LearningModel learningModelFromJson(String str) => LearningModel.fromJson(json.decode(str));

String learningModelToJson(LearningModel data) => json.encode(data.toJson());

class LearningModel {
  String? id;
  String? type;
  String? title;
  dynamic thumbnailUrl;
  String? videoUrl;
  dynamic pdfUrl;
  bool? isActive;
  dynamic sectorId;
  String? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic sector;
  List<dynamic>? quizQuestions;

  LearningModel({
    this.id,
    this.type,
    this.title,
    this.thumbnailUrl,
    this.videoUrl,
    this.pdfUrl,
    this.isActive,
    this.sectorId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.sector,
    this.quizQuestions,
  });

  factory LearningModel.fromJson(Map<String, dynamic> json) => LearningModel(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    thumbnailUrl: json["thumbnailUrl"],
    videoUrl: json["videoUrl"],
    pdfUrl: json["pdfUrl"],
    isActive: json["isActive"],
    sectorId: json["sectorId"],
    createdById: json["createdById"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    sector: json["sector"],
    quizQuestions: json["quizQuestions"] == null ? [] : List<dynamic>.from(json["quizQuestions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "thumbnailUrl": thumbnailUrl,
    "videoUrl": videoUrl,
    "pdfUrl": pdfUrl,
    "isActive": isActive,
    "sectorId": sectorId,
    "createdById": createdById,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "sector": sector,
    "quizQuestions": quizQuestions == null ? [] : List<dynamic>.from(quizQuestions!.map((x) => x)),
  };
}
