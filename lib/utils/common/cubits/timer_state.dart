// timer_state.dart
part of 'timer_cubit.dart';

enum TimerStatus { initial, running, finished }

class TimerState extends Equatable {
  final TimerStatus status;
  final int secondsRemaining;

  const TimerState._({required this.status, this.secondsRemaining = 0});

  const TimerState.initial() : this._(status: TimerStatus.initial);

  const TimerState.running({required int secondsRemaining})
    : this._(status: TimerStatus.running, secondsRemaining: secondsRemaining);

  const TimerState.finished() : this._(status: TimerStatus.finished);

  bool get isInitial => status == TimerStatus.initial;

  bool get isRunning => status == TimerStatus.running;

  bool get isFinished => status == TimerStatus.finished;

  @override
  List<Object> get props => [status, secondsRemaining];
}
