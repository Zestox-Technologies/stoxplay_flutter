// To parse this JSON data, do
//
//     final playingHistoryModel = playingHistoryModelFromJson(jsonString);

import 'dart:convert';

PlayingHistoryModel playingHistoryModelFromJson(String str) => PlayingHistoryModel.fromJson(json.decode(str));

String playingHistoryModelToJson(PlayingHistoryModel data) => json.encode(data.toJson());

class PlayingHistoryModel {
  List<Datum>? data;
  Meta? meta;

  PlayingHistoryModel({
    this.data,
    this.meta,
  });

  factory PlayingHistoryModel.fromJson(Map<String, dynamic> json) => PlayingHistoryModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  String? id;
  String? name;
  int? rank;
  double? points;
  int? prize;
  Contest? contest;

  Datum({
    this.id,
    this.name,
    this.rank,
    this.points,
    this.prize,
    this.contest,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    rank: json["rank"],
    points: json["points"]?.toDouble(),
    prize: json["prize"],
    contest: json["contest"] == null ? null : Contest.fromJson(json["contest"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rank": rank,
    "points": points,
    "prize": prize,
    "contest": contest?.toJson(),
  };
}

class Contest {
  String? id;
  String? name;
  String? sectorName;
  String? sectorLogo;
  String? status;
  int? entryFee;
  int? prizePool;
  int? teamsPerUser;
  int? winningPercentage;

  Contest({
    this.id,
    this.name,
    this.sectorName,
    this.sectorLogo,
    this.status,
    this.entryFee,
    this.prizePool,
    this.teamsPerUser,
    this.winningPercentage,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"],
    name: json["name"],
    sectorName: json["sectorName"],
    sectorLogo: json["sectorLogo"],
    status: json["status"],
    entryFee: json["entryFee"],
    prizePool: json["prizePool"],
    teamsPerUser: json["teamsPerUser"],
    winningPercentage: json["winningPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sectorName": sectorName,
    "sectorLogo": sectorLogo,
    "status": status,
    "entryFee": entryFee,
    "prizePool": prizePool,
    "teamsPerUser": teamsPerUser,
    "winningPercentage": winningPercentage,
  };
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
  };
}
