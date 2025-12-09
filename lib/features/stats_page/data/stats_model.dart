
import 'dart:convert';


StatsModel statsModelFromJson(String str) {
  try {
    return StatsModel.fromJson(json.decode(str));
  } catch (e) {
    // Return a default model if parsing fails
    return StatsModel();
  }
}

String statsModelToJson(StatsModel data) => json.encode(data.toJson());

class StatsModel {
  final List<StatsDataModel>? upcoming;
  final List<StatsDataModel>? live;
  final List<StatsDataModel>? completed;

  StatsModel({this.upcoming, this.live, this.completed});

  factory StatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StatsModel();

    return StatsModel(
      upcoming: _parseStatsDataList(json["upcoming"]),
      live: _parseStatsDataList(json["live"]),
      completed: _parseStatsDataList(json["completed"]),
    );
  }

  static List<StatsDataModel>? _parseStatsDataList(dynamic data) {
    if (data == null) return null;
    if (data is! List) return null;

    try {
      return List<StatsDataModel>.from(data.map((x) => StatsDataModel.fromJson(x)).where((x) => x != null));
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    "upcoming": upcoming?.map((x) => x.toJson()).toList() ?? [],
    "live": live?.map((x) => x.toJson()).toList() ?? [],
    "completed": completed?.map((x) => x.toJson()).toList() ?? [],
  };
}


StatsDataModel statsDataModelFromJson(String str) => StatsDataModel.fromJson(json.decode(str));

String statsDataModelToJson(StatsDataModel data) => json.encode(data.toJson());

class StatsDataModel {
  String? id;
  String? name;
  dynamic rank;
  dynamic points;
  dynamic prize;
  Contest? contest;

  StatsDataModel({
    this.id,
    this.name,
    this.rank,
    this.points,
    this.prize,
    this.contest,
  });

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
  String? id;
  String? name;
  String? sectorName;
  String? sectorLogo;
  int? entryFee;
  int? prizePool;
  int? winningPercentage;
  TimeLeft? timeLeft;
  int? spotsRemaining;
  int? spotsFilled;
  int? totalSpots;
  int? firstPrize;


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
    this.spotsFilled,
    this.totalSpots,
    this.firstPrize,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"],
    name: json["name"],
    sectorName: json["sectorName"],
    sectorLogo: json["sectorLogo"],
    entryFee: json["entryFee"],
    prizePool: json["prizePool"],
    winningPercentage: json["winningPercentage"],
    timeLeft: json["timeLeft"] == null ? null : TimeLeft.fromJson(json["timeLeft"]),
    spotsRemaining: json["spotsRemaining"],
    spotsFilled: json["spotsFilled"],
    totalSpots: json["totalSpots"],
    firstPrize: json["firstPrize"],
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
    "spotsFilled": spotsFilled,
    "totalSpots": totalSpots,
    "firstPrize": firstPrize,
  };
}

class TimeLeft {
  String? status;
  int? days;
  int? hours;
  int? minutes;
  int? seconds;

  TimeLeft({
    this.status,
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
  });

  factory TimeLeft.fromJson(Map<String, dynamic> json) => TimeLeft(
    status: json["status"],
    days: json["days"],
    hours: json["hours"],
    minutes: json["minutes"],
    seconds: json["seconds"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "days": days,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
  };
}
