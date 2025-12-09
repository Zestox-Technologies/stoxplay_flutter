class LiveStock {
  final String stockId;
  final String symbol;
  final num points;
  final num currentPrice;
  final num netChange;
  final num? percentageChange;
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
    required this.percentageChange,
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
      percentageChange: json['percentageChange'].toDouble(),
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
      'percentageChange': percentageChange,
    };
  }
}

class ScoreUpdatePayload {
  final String userTeamId;
  final String contestId;
  final String contestName;
  final num totalPoints;
  final int rank;
  final int entryFee;
  final bool isLive;
  final List<LiveStock> liveStocks;

  ScoreUpdatePayload({
    required this.userTeamId,
    required this.totalPoints,
    required this.rank,
    required this.liveStocks,
    required this.contestId,
    required this.contestName,
    required this.entryFee,
    required this.isLive,
  });

  factory ScoreUpdatePayload.fromJson(Map<String, dynamic> json) {
    return ScoreUpdatePayload(
      userTeamId: json['userTeamId'],
      totalPoints: json['totalPoints'],
      rank: json['rank'],
      liveStocks: (json['liveStocks'] as List<dynamic>).map((e) => LiveStock.fromJson(e)).toList(),
      contestId: json['contestId'],
      contestName: json['contestName'],
      entryFee: json['entryFee'],
      isLive: json['isLive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userTeamId': userTeamId,
      'totalPoints': totalPoints,
      'rank': rank,
      'liveStocks': liveStocks.map((e) => e.toJson()).toList(),
      'contestId': contestId,
      'contestName': contestName,
      'entryFee': entryFee,
      'isLive': isLive,
    };
  }
}
