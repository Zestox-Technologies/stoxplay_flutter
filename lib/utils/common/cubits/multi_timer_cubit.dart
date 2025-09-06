import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'multi_timer_state.dart';

class MultiTimerCubit extends Cubit<MultiTimerState> {
  static MultiTimerCubit? _instance;
  
  static MultiTimerCubit get instance {
    _instance ??= MultiTimerCubit._();
    return _instance!;
  }
  
  MultiTimerCubit._() : super(const MultiTimerState());

  final Map<String, Timer> _timers = {};
  final Map<String, int> _remainingSeconds = {};

  void startTimer({required String contestId, required int seconds}) {
    print('MultiTimerCubit: Starting timer for contest $contestId with $seconds seconds');
    
    // Cancel existing timer for this contest
    _timers[contestId]?.cancel();
    
    // Initialize remaining seconds
    _remainingSeconds[contestId] = seconds;
    
    // Emit initial state for this contest
    emit(state.copyWith(
      timers: Map.from(_remainingSeconds),
    ));

    // Start new timer
    _timers[contestId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSeconds = _remainingSeconds[contestId] ?? 0;

      if (currentSeconds > 1) {
        _remainingSeconds[contestId] = currentSeconds - 1;
        emit(state.copyWith(
          timers: Map.from(_remainingSeconds),
        ));
      } else {
        _remainingSeconds[contestId] = 0;
        emit(state.copyWith(
          timers: Map.from(_remainingSeconds),
        ));
        timer.cancel();
        _timers.remove(contestId);
      }
    });
  }

  void stopTimer(String contestId) {
    _timers[contestId]?.cancel();
    _timers.remove(contestId);
    _remainingSeconds.remove(contestId);
    emit(state.copyWith(
      timers: Map.from(_remainingSeconds),
    ));
  }

  void stopAllTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _remainingSeconds.clear();
    emit(const MultiTimerState());
  }

  int getRemainingSeconds(String contestId) {
    return _remainingSeconds[contestId] ?? 0;
  }

  @override
  Future<void> close() {
    stopAllTimers();
    return super.close();
  }
}
