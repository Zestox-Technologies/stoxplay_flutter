/// Arguments model for navigating to the Battleground page.
///
/// This model provides a type-safe way to pass navigation arguments,
/// replacing the previous tuple-based approach.
class BattlegroundArguments {
  /// The ID of the team to display
  final String teamId;

  /// The name of the team to show in the header
  final String teamName;

  /// Flag indicating if navigation is from a live contest
  /// Defaults to false for backward compatibility
  final bool isFromLive;

  const BattlegroundArguments({
    required this.teamId,
    required this.teamName,
    this.isFromLive = false,
  });

  /// Creates a copy of this arguments object with optional field overrides
  BattlegroundArguments copyWith({
    String? teamId,
    String? teamName,
    bool? isFromLive,
  }) {
    return BattlegroundArguments(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      isFromLive: isFromLive ?? this.isFromLive,
    );
  }

  @override
  String toString() {
    return 'BattlegroundArguments(teamId: $teamId, teamName: $teamName, isFromLive: $isFromLive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BattlegroundArguments &&
        other.teamId == teamId &&
        other.teamName == teamName &&
        other.isFromLive == isFromLive;
  }

  @override
  int get hashCode => teamId.hashCode ^ teamName.hashCode ^ isFromLive.hashCode;
}
