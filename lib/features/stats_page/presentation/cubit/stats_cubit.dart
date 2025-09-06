import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/cubits/multi_timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  GetMyContestUseCase getMyContestUseCase;
  MultiTimerCubit multiTimerCubit;

  StatsCubit({required this.getMyContestUseCase}) : multiTimerCubit = MultiTimerCubit.instance, super(StatsState());

  Future<void> getMyContests() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final response = await getMyContestUseCase.call('');

      response.fold(
        (l) {
          emit(state.copyWith(errorMessage: l.message, apiStatus: ApiStatus.failed));
        },
        (r) {
          // Stop all existing timers
          multiTimerCubit.stopAllTimers();
          
          // Start individual timers for each upcoming contest
          if (r.upcoming?.isNotEmpty ?? false) {
            for (final contest in r.upcoming!) {
              if (contest.contest?.timeLeft != null && contest.id != null) {
                final totalSeconds = getTotalSecondsFromTimeLeft(contest.contest!.timeLeft!);
                if (totalSeconds > 0) {
                  multiTimerCubit.startTimer(
                    contestId: contest.id!,
                    seconds: totalSeconds,
                  );
                }
              }
            }
          }
          
          final stats = StatsModel.fromJson(r.toJson());
          emit(state.copyWith(stats: stats, apiStatus: ApiStatus.success));
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
