// To parse this JSON data, do
//
//     final mostPickedStock = mostPickedStockFromJson(jsonString);

import 'dart:convert';

List<MostPickedStock> mostPickedStockFromJson(String str) =>
    List<MostPickedStock>.from(json.decode(str).map((x) => MostPickedStock.fromJson(x)));

String mostPickedStockToJson(List<MostPickedStock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MostPickedStock {
  String? id;
  String? symbol;
  String? name;
  String? logoUrl;
  int? selectionCount;

  MostPickedStock({this.id, this.symbol, this.name, this.logoUrl, this.selectionCount});

  factory MostPickedStock.fromJson(Map<String, dynamic> json) => MostPickedStock(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    logoUrl: json["logoUrl"],
    selectionCount: json["selectionCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "logoUrl": logoUrl,
    "selectionCount": selectionCount,
  };
}