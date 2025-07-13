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
    this.createdAt,
    this.updatedAt,
  });

  factory StockDataModel.fromJson(Map<String, dynamic> json) => StockDataModel(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    instrumentKey: json["instrumentKey"],
    logoUrl: json["logoUrl"],
    currentPrice: json["currentPrice"]?.toDouble(),
    isActive: json["isActive"],
    sectorId: json["sectorId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "instrumentKey": instrumentKey,
    "logoUrl": logoUrl,
    "currentPrice": currentPrice,
    "isActive": isActive,
    "sectorId": sectorId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
