class JoinContestParamsModel {
  final String contestId;
  final String teamName;
  final List<SelectedStock> selectedStocks;
  final String captainStockId;
  final String viceCaptainStockId;
  final String flexStockId;

  JoinContestParamsModel({
    required this.contestId,
    required this.teamName,
    required this.selectedStocks,
    required this.captainStockId,
    required this.viceCaptainStockId,
    required this.flexStockId,
  });

  Map<String, dynamic> toJson() => {
    'teamName': teamName,
    'selectedStocks': selectedStocks.map((s) => s.toJson()).toList(),
    'captainStockId': captainStockId,
    'viceCaptainStockId': viceCaptainStockId,
    'flexStockId': flexStockId,
  };
}

class SelectedStock {
  final String stockId;
  final String prediction;

  SelectedStock({required this.stockId, required this.prediction});

  Map<String, dynamic> toJson() => {'stockId': stockId, 'prediction': prediction};
}
