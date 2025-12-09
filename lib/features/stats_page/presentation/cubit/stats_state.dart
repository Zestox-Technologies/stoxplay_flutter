part of 'stats_cubit.dart';

@immutable
class StatsState extends Equatable {
  final ApiStatus apiStatus;
  final String errorMessage;
  final StatsModel? stats;

  const StatsState({this.apiStatus = ApiStatus.initial, this.errorMessage = '', this.stats});

  StatsState copyWith({ApiStatus? apiStatus, String? errorMessage, StatsModel? stats}) {
    return StatsState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [apiStatus, errorMessage, stats];
}
