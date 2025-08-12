// timer_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState.initial());

  Timer? _timer;

  void startTimer({required int seconds}) {
    print('TimerCubit: Starting timer with $seconds seconds');
    _timer?.cancel(); // cancel any existing timer
    emit(TimerState.running(secondsRemaining: seconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSeconds = state.secondsRemaining;

      if (currentSeconds > 1) {
        emit(TimerState.running(secondsRemaining: currentSeconds - 1));
      } else {
        emit(const TimerState.finished());
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    emit(const TimerState.initial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
