// To parse this JSON data, do
//
//     final contestLeaderboardModel = contestLeaderboardModelFromJson(jsonString);

import 'dart:convert';

ContestLeaderboardModel contestLeaderboardModelFromJson(String str) => ContestLeaderboardModel.fromJson(json.decode(str));

String contestLeaderboardModelToJson(ContestLeaderboardModel data) => json.encode(data.toJson());

class ContestLeaderboardModel {
  ContestInfo? contestInfo;
  MyRank? myRank;
  List<Leaderboard>? leaderboard;
  Meta? meta;

  ContestLeaderboardModel({
    this.contestInfo,
    this.myRank,
    this.leaderboard,
    this.meta,
  });

  factory ContestLeaderboardModel.fromJson(Map<String, dynamic> json) => ContestLeaderboardModel(
    contestInfo: json["contestInfo"] == null ? null : ContestInfo.fromJson(json["contestInfo"]),
    myRank: json["myRank"] == null ? null : MyRank.fromJson(json["myRank"]),
    leaderboard: json["leaderboard"] == null ? [] : List<Leaderboard>.from(json["leaderboard"]!.map((x) => Leaderboard.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "contestInfo": contestInfo?.toJson(),
    "myRank": myRank?.toJson(),
    "leaderboard": leaderboard == null ? [] : List<dynamic>.from(leaderboard!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class ContestInfo {
  int? spotsFilled;
  int? totalSpots;

  ContestInfo({
    this.spotsFilled,
    this.totalSpots,
  });

  factory ContestInfo.fromJson(Map<String, dynamic> json) => ContestInfo(
    spotsFilled: json["spotsFilled"],
    totalSpots: json["totalSpots"],
  );

  Map<String, dynamic> toJson() => {
    "spotsFilled": spotsFilled,
    "totalSpots": totalSpots,
  };
}

class Leaderboard {
  String? teamName;
  int? rank;
  int? prize;
  double? points;
  User? user;

  Leaderboard({
    this.teamName,
    this.rank,
    this.prize,
    this.points,
    this.user,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
    teamName: json["teamName"],
    rank: json["rank"],
    prize: json["prize"],
    points: json["points"]?.toDouble(),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "teamName": teamName,
    "rank": rank,
    "prize": prize,
    "points": points,
    "user": user?.toJson(),
  };
}

class User {
  String? name;
  String? profilePictureUrl;

  User({
    this.name,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    profilePictureUrl: json["profilePictureUrl"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profilePictureUrl": profilePictureUrl,
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

class MyRank {
  int? rank;
  double? points;
  int? prize;

  MyRank({
    this.rank,
    this.points,
    this.prize,
  });

  factory MyRank.fromJson(Map<String, dynamic> json) => MyRank(
    rank: json["rank"],
    points: json["points"]?.toDouble(),
    prize: json["prize"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "points": points,
    "prize": prize,
  };
}
