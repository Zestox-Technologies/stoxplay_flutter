import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';

class ContestStaticModel {
  final String title;
  final String price;
  final String timeLeft;
  final String image;
  final List<ContestPrice> contestPriceList;
  final List<Stock> stocks;

  ContestStaticModel({
    required this.title,
    required this.price,
    required this.timeLeft,
    required this.image,
    required this.contestPriceList,
    required this.stocks,
  });

  factory ContestStaticModel.fromJson(Map<String, dynamic> json) {
    return ContestStaticModel(
      title: json['title'] as String,
      price: json['price'] as String,
      timeLeft: json['timeLeft'] as String,
      image: json['image'] as String,
      contestPriceList: (json['contestPriceList'] as List).map((e) => ContestPrice.fromJson(e)).toList(),
      stocks: (json['stocks'] as List).map((e) => Stock.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'timeLeft': timeLeft,
      'image': image,
      'contestPriceList': contestPriceList.map((e) => e.toJson()).toList(),
      'stocks': stocks.map((e) => e.toJson()).toList(),
    };
  }
}

class ContestPrice {
  final int contestPrice;
  final String spots;
  final String prizePool;

  ContestPrice({required this.contestPrice, required this.spots, required this.prizePool});

  factory ContestPrice.fromJson(Map<String, dynamic> json) {
    return ContestPrice(
      contestPrice: json['contestPrice'] as int,
      spots: json['spots'] as String,
      prizePool: json['prizePool'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'contestPrice': contestPrice, 'spots': spots, 'prizePool': prizePool};
  }
}

class Stock {
  String? stockName;
  String? id;
  String? stockPrice;
  String? percentage;
  String? image;
  StockPrediction stockPrediction;
  StockPosition stockPosition;
  String? currentPrice;
  double? netChange;
  bool isLiveData;
  int? livePoints;
  DateTime? lastUpdated;

  Stock({
    this.stockName,
    this.id,
    this.stockPrice,
    this.percentage,
    this.image,
    this.currentPrice,
    this.netChange,
    this.stockPrediction = StockPrediction.none,
    this.stockPosition = StockPosition.none,
    this.isLiveData = false,
    this.livePoints,
    this.lastUpdated,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockName: json['stockName'] as String?,
      id: json['id'] as String?,
      stockPrice: json['stockPrice'] as String?,
      percentage: json['percentage'] as String?,
      image: json['image'] as String?,
      currentPrice: json['currentPrice'] as String?,
      netChange: json['netChange'],
      stockPrediction: _parseStockPrediction(json['prediction']),
      stockPosition: _parseStockPosition(json['stockPosition']),
    );
  }

  static StockPrediction _parseStockPrediction(dynamic value) {
    if (value is String) {
      return StockPrediction.values.firstWhere(
        (e) => e.toString().split('.').last == value,
        orElse: () => StockPrediction.none,
      );
    }
    return StockPrediction.none;
  }

  static StockPosition _parseStockPosition(dynamic value) {
    if (value is String) {
      return StockPosition.values.firstWhere(
        (e) => e.toString().split('.').last == value,
        orElse: () => StockPosition.none,
      );
    }
    return StockPosition.none;
  }

  Map<String, dynamic> toJson() {
    return {
      'stockName': stockName,
      'id': id,
      'stockPrice': stockPrice,
      'percentage': percentage,
      'image': image,
      'currentPrice': currentPrice,
      'netChange': netChange,
      'prediction': stockPrediction.toString().split('.').last,
      'stockPosition': stockPosition.toString().split('.').last,
      'isLiveData': isLiveData,
      'livePoints': livePoints,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}

extension StockCopyWith on Stock {
  Stock copyWith({
    String? stockName,
    String? id,
    String? stockPrice,
    String? percentage,
    String? image,
    StockPrediction? stockPrediction,
    StockPosition? stockPosition,
    String? currentPrice,
    double? netChange,
    bool? isLiveData,
    int? livePoints,
    DateTime? lastUpdated,
  }) {
    return Stock(
      stockName: stockName ?? this.stockName,
      id: id ?? this.id,
      stockPrice: stockPrice ?? this.stockPrice,
      percentage: percentage ?? this.percentage,
      image: image ?? this.image,
      stockPrediction: stockPrediction ?? this.stockPrediction,
      stockPosition: stockPosition ?? this.stockPosition,
      currentPrice: currentPrice ?? this.currentPrice,
      netChange: netChange ?? this.netChange,
      isLiveData: isLiveData ?? this.isLiveData,
      livePoints: livePoints ?? this.livePoints,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
