class LiveStock {
  final String stockId;
  final String symbol;
  final double points;
  final double currentPrice;
  final double netChange;
  final bool isPredictionCorrect;
  final String role;
  final String logoUrl;
  final String prediction;

  LiveStock({
    required this.stockId,
    required this.symbol,
    required this.points,
    required this.currentPrice,
    required this.netChange,
    required this.isPredictionCorrect,
    required this.role,
    required this.logoUrl,
    required this.prediction,
  });

  factory LiveStock.fromJson(Map<String, dynamic> json) {
    return LiveStock(
      stockId: json['stockId'],
      symbol: json['symbol'],
      points: json['points'].toDouble(),
      currentPrice: json['currentPrice'].toDouble(),
      netChange: json['netChange'].toDouble(),
      isPredictionCorrect: json['isPredictionCorrect'],
      role: json['role'],
      logoUrl: json['logoUrl'],
      prediction: json['prediction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'symbol': symbol,
      'points': points,
      'currentPrice': currentPrice,
      'netChange': netChange,
      'isPredictionCorrect': isPredictionCorrect,
      'role': role,
      'logoUrl': logoUrl,
      'prediction': prediction,
    };
  }
}

class ScoreUpdatePayload {
  final String userTeamId;
  final double totalPoints;
  final int rank;
  final List<LiveStock> liveStocks;

  ScoreUpdatePayload({
    required this.userTeamId,
    required this.totalPoints,
    required this.rank,
    required this.liveStocks,
  });

  factory ScoreUpdatePayload.fromJson(Map<String, dynamic> json) {
    return ScoreUpdatePayload(
      userTeamId: json['userTeamId'],
      totalPoints: json['totalPoints'],
      rank: json['rank'],
      liveStocks: (json['liveStocks'] as List<dynamic>).map((e) => LiveStock.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userTeamId': userTeamId,
      'totalPoints': totalPoints,
      'rank': rank,
      'liveStocks': liveStocks.map((e) => e.toJson()).toList(),
    };
  }
}
