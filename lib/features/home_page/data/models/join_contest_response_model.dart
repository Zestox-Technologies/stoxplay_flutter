class JoinContestResponseModel {
  final String id;
  final String name;
  final String userId;
  final String contestId;
  final int? points;
  final int? rank;
  final int? prize;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TeamStock> stocks;

  JoinContestResponseModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.contestId,
    this.points,
    this.rank,
    this.prize,
    required this.createdAt,
    required this.updatedAt,
    required this.stocks,
  });

  factory JoinContestResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinContestResponseModel(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      contestId: json['contestId'],
      points: json['points'],
      rank: json['rank'],
      prize: json['prize'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      stocks: (json['stocks'] as List<dynamic>)
          .map((stock) => TeamStock.fromJson(stock))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'contestId': contestId,
      'points': points,
      'rank': rank,
      'prize': prize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'stocks': stocks.map((stock) => stock.toJson()).toList(),
    };
  }
}

class TeamStock {
  final String userTeamId;
  final String stockId;
  final String prediction;
  final String role;

  TeamStock({
    required this.userTeamId,
    required this.stockId,
    required this.prediction,
    required this.role,
  });

  factory TeamStock.fromJson(Map<String, dynamic> json) {
    return TeamStock(
      userTeamId: json['userTeamId'],
      stockId: json['stockId'],
      prediction: json['prediction'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userTeamId': userTeamId,
      'stockId': stockId,
      'prediction': prediction,
      'role': role,
    };
  }
} 