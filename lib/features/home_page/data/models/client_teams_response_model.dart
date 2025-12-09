import 'dart:convert';

import 'package:stoxplay/features/stats_page/data/stats_model.dart';

ClientTeamsResponseModel clientTeamsResponseModelFromJson(String str) =>
    ClientTeamsResponseModel.fromJson(json.decode(str));

String clientTeamsResponseModelToJson(ClientTeamsResponseModel data) => json.encode(data.toJson());

class ClientTeamsResponseModel {
  String? id;
  String? name;
  dynamic rank;
  dynamic points;
  dynamic prize;
  Contest? contest;
  List<ClientTeamsStock>? stocks;

  ClientTeamsResponseModel({this.id, this.name, this.rank, this.points, this.prize, this.contest, this.stocks});

  factory ClientTeamsResponseModel.fromJson(Map<String, dynamic> json) => ClientTeamsResponseModel(
    id: json["id"],
    name: json["name"],
    rank: json["rank"],
    points: json["points"],
    prize: json["prize"],
    contest: json["contest"] == null ? null : Contest.fromJson(json["contest"]),
    stocks:
        json["stocks"] == null
            ? []
            : List<ClientTeamsStock>.from(json["stocks"]!.map((x) => ClientTeamsStock.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rank": rank,
    "points": points,
    "prize": prize,
    "contest": contest?.toJson(),
    "stocks": stocks == null ? [] : List<dynamic>.from(stocks!.map((x) => x.toJson())),
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
    timeLeft: json["timeLeft"] == null ? null : TimeLeft.fromJson(json["timeLeft"]),
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

class ClientTeamsStock {
  String? stockId;
  String? symbol;
  String? name;
  String? logoUrl;
  String? prediction;
  String? role;

  ClientTeamsStock({this.stockId, this.symbol, this.name, this.logoUrl, this.prediction, this.role});

  factory ClientTeamsStock.fromJson(Map<String, dynamic> json) => ClientTeamsStock(
    stockId: json["stockId"],
    symbol: json["symbol"],
    name: json["name"],
    logoUrl: json["logoUrl"],
    prediction: json["prediction"] == null ? null : json["prediction"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "stockId": stockId,
    "symbol": symbol,
    "name": name,
    "logoUrl": logoUrl,
    "prediction": prediction,
    "role": role,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
