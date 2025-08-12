// To parse this JSON data, do
//
//     final statsModel = statsModelFromJson(jsonString);

import 'dart:convert';

import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';

StatsModel statsModelFromJson(String str) => StatsModel.fromJson(json.decode(str));

String statsModelToJson(StatsModel data) => json.encode(data.toJson());

class StatsModel {
  final List<StatsDataModel>? upcoming;
  final List<StatsDataModel>? live;
  final List<StatsDataModel>? completed;

  StatsModel({this.upcoming, this.live, this.completed});

  factory StatsModel.fromJson(Map<String, dynamic> json) => StatsModel(
    upcoming:
        json["upcoming"] == null
            ? []
            : List<StatsDataModel>.from(json["upcoming"]!.map((x) => StatsDataModel.fromJson(x))),
    live: json["live"] == null ? [] : List<StatsDataModel>.from(json["live"]!.map((x) => StatsDataModel.fromJson(x))),
    completed:
        json["completed"] == null
            ? []
            : List<StatsDataModel>.from(json["completed"]!.map((x) => StatsDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "upcoming": upcoming == null ? [] : List<dynamic>.from(upcoming!.map((x) => x.toJson())),
    "live": live == null ? [] : List<dynamic>.from(live!.map((x) => x.toJson())),
    "completed": completed == null ? [] : List<dynamic>.from(completed!.map((x) => x.toJson())),
  };
}

class StatsDataModel {
  final String? id;
  final String? name;
  final int? rank;
  final int? points;
  final int? prize;
  final Contest? contest;

  StatsDataModel({this.id, this.name, this.rank, this.points, this.prize, this.contest});

  factory StatsDataModel.fromJson(Map<String, dynamic> json) => StatsDataModel(
    id: json["id"],
    name: json["name"],
    rank: json["rank"],
    points: json["points"],
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
  final String? id;
  final String? name;
  final String? sectorName;
  final String? sectorLogo;
  final int? entryFee;
  final int? prizePool;
  final int? winningPercentage;
  final TimeLeftToStartModel? timeLeft;
  final int? spotsRemaining;

  Contest({
    this.id,
    this.name,
    this.sectorName,
    this.sectorLogo,
    this.entryFee,
    this.prizePool,
    this.winningPercentage,
    this.timeLeft,
    this.spotsRemaining,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"],
    name: json["name"],
    sectorName: json["sectorName"],
    sectorLogo: json["sectorLogo"],
    entryFee: json["entryFee"],
    prizePool: json["prizePool"],
    winningPercentage: json["winningPercentage"],
    timeLeft: json["timeLeft"] == null ? null : TimeLeftToStartModel.fromJson(json["timeLeft"]),
    spotsRemaining: json["spotsRemaining"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sectorName": sectorName,
    "sectorLogo": sectorLogo,
    "entryFee": entryFee,
    "prizePool": prizePool,
    "winningPercentage": winningPercentage,
    "timeLeft": timeLeft?.toJson(),
    "spotsRemaining": spotsRemaining,
  };
}
