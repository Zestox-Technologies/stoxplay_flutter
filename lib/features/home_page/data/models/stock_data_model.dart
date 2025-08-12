import 'dart:convert';

StockDataModel stockDataModelFromJson(String str) => StockDataModel.fromJson(json.decode(str));

String stockDataModelToJson(StockDataModel data) => json.encode(data.toJson());

class StockDataModel {
  final String? id;
  final String? symbol;
  final String? name;
  final String? instrumentKey;
  final String? logoUrl;
  final double? currentPrice;
  final bool? isActive;
  final String? sectorId;
  final double? previousDayClose;
  final double? netChange;
  final double? percentageChange;
  final int? selectionPercentage;
  final int? captainSelectionPercentage;
  final int? viceCaptainSelectionPercentage;
  final int? flexSelectionPercentage;
  final int? upPredictionPercentage;
  final int? downPredictionPercentage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StockDataModel({
    this.id,
    this.symbol,
    this.name,
    this.instrumentKey,
    this.logoUrl,
    this.currentPrice,
    this.isActive,
    this.sectorId,
    this.previousDayClose,
    this.netChange,
    this.percentageChange,
    this.selectionPercentage,
    this.captainSelectionPercentage,
    this.viceCaptainSelectionPercentage,
    this.flexSelectionPercentage,
    this.upPredictionPercentage,
    this.downPredictionPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory StockDataModel.fromJson(Map<String, dynamic> json) {
    return StockDataModel(
      id: json["id"],
      symbol: json["symbol"],
      name: json["name"],
      instrumentKey: json["instrumentKey"],
      logoUrl: json["logoUrl"],
      currentPrice: (json["currentPrice"] as num?)?.toDouble(),
      isActive: json["isActive"],
      sectorId: json["sectorId"],
      previousDayClose: (json["previousDayClose"] as num?)?.toDouble(),
      netChange: (json["netChange"] as num?)?.toDouble(),
      percentageChange: (json["percentageChange"] as num?)?.toDouble(),
      selectionPercentage: json["selectionPercentage"] ?? 0,
      captainSelectionPercentage: json["captainSelectionPercentage"] ?? 0,
      viceCaptainSelectionPercentage: json["viceCaptainSelectionPercentage"] ?? 0,
      flexSelectionPercentage: json["flexSelectionPercentage"] ?? 0,
      upPredictionPercentage: json["upPredictionPercentage"] ?? 0,
      downPredictionPercentage: json["downPredictionPercentage"] ?? 0,
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "symbol": symbol,
      "name": name,
      "instrumentKey": instrumentKey,
      "logoUrl": logoUrl,
      "currentPrice": currentPrice,
      "isActive": isActive,
      "sectorId": sectorId,
      "previousDayClose": previousDayClose,
      "netChange": netChange,
      "percentageChange": percentageChange,
      "selectionPercentage": selectionPercentage ?? "0.00",
      "captainSelectionPercentage": captainSelectionPercentage ?? "0.00",
      "viceCaptainSelectionPercentage": viceCaptainSelectionPercentage ?? "0.00",
      "flexSelectionPercentage": flexSelectionPercentage ?? "0.00",
      "upPredictionPercentage": upPredictionPercentage ?? "0.00",
      "downPredictionPercentage": downPredictionPercentage ?? "0.00",
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class TimeLeftToStartModel {
  final String status;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  TimeLeftToStartModel({
    required this.status,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory TimeLeftToStartModel.fromJson(Map<String, dynamic> json) {
    return TimeLeftToStartModel(
      status: json['status'],
      days: json['days'],
      hours: json['hours'],
      minutes: json['minutes'],
      seconds: json['seconds'],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "days": days,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
  };
}

class StockResponseModel {
  final TimeLeftToStartModel timeLeftToStart;
  final List<StockDataModel> stocks;

  StockResponseModel({required this.timeLeftToStart, required this.stocks});

  factory StockResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return StockResponseModel(
      timeLeftToStart: TimeLeftToStartModel.fromJson(data['timeLeftToStart']),
      stocks: (data['stocks'] as List).map((item) => StockDataModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'timeLeftToStart': timeLeftToStart.toJson(), 'stocks': stocks.map((stock) => stock.toJson()).toList()};
  }
}
