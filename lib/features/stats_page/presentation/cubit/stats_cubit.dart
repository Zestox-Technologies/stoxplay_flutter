import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  GetMyContestUseCase getMyContestUseCase;
  TimerCubit timerCubit = TimerCubit();

  StatsCubit({required this.getMyContestUseCase}) : super(StatsState());

  Future<void> getMyContests() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final response = await getMyContestUseCase.call('');

      response.fold(
        (l) {
          emit(state.copyWith(errorMessage: l.message, apiStatus: ApiStatus.failed));
        },
        (r) {
          final totalSeconds =
              ((r.upcoming?.isNotEmpty ?? false) && r.upcoming?.first.contest?.timeLeft != null)
                  ? getTotalSecondsFromTimeLeft(r.upcoming?.first.contest?.timeLeft ?? TimeLeft())
                  : 0;
          timerCubit.startTimer(seconds: totalSeconds);
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
