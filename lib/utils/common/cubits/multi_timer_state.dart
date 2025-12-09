part of 'multi_timer_cubit.dart';

class MultiTimerState extends Equatable {
  final Map<String, int> timers;

  const MultiTimerState({this.timers = const {}});

  MultiTimerState copyWith({Map<String, int>? timers}) {
    return MultiTimerState(
      timers: timers ?? this.timers,
    );
  }

  int getRemainingSeconds(String contestId) {
    return timers[contestId] ?? 0;
  }

  bool isTimerRunning(String contestId) {
    return timers.containsKey(contestId) && (timers[contestId] ?? 0) > 0;
  }

  @override
  List<Object> get props => [timers];
}
