// To parse this JSON data, do
//
//     final mostPickedStock = mostPickedStockFromJson(jsonString);

import 'dart:convert';

MostPickedStock mostPickedStockFromJson(String str) => MostPickedStock.fromJson(json.decode(str));

String mostPickedStockToJson(MostPickedStock data) => json.encode(data.toJson());

class MostPickedStock {
  String? id;
  String? symbol;
  String? name;
  String? logoUrl;
  String? sectorName;
  double? currentPrice;
  double? netChange;
  double? percentageChange;
  int? selectionCount;
  int? upPredictionCount;
  int? downPredictionCount;

  MostPickedStock({
    this.id,
    this.symbol,
    this.name,
    this.logoUrl,
    this.sectorName,
    this.currentPrice,
    this.netChange,
    this.percentageChange,
    this.selectionCount,
    this.upPredictionCount,
    this.downPredictionCount,
  });

  factory MostPickedStock.fromJson(Map<String, dynamic> json) => MostPickedStock(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    logoUrl: json["logoUrl"],
    sectorName: json["sectorName"],
    currentPrice: json["currentPrice"]?.toDouble(),
    netChange: json["netChange"]?.toDouble(),
    percentageChange: json["percentageChange"]?.toDouble(),
    selectionCount: json["selectionCount"],
    upPredictionCount: json["upPredictionCount"],
    downPredictionCount: json["downPredictionCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "logoUrl": logoUrl,
    "sectorName": sectorName,
    "currentPrice": currentPrice,
    "netChange": netChange,
    "percentageChange": percentageChange,
    "selectionCount": selectionCount,
    "upPredictionCount": upPredictionCount,
    "downPredictionCount": downPredictionCount,
  };
}
