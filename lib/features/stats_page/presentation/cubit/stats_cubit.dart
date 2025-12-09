import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/common/cubits/multi_timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  GetMyContestUseCase getMyContestUseCase;
  MultiTimerCubit multiTimerCubit;

  StatsCubit({required this.getMyContestUseCase}) : multiTimerCubit = MultiTimerCubit.instance, super(StatsState());

  Future<void> getMyContests({bool forceRefresh = false}) async {
    // Check if we already have valid cached data
    if (!forceRefresh && state.stats != null) {
      return; // Data already loaded
    }

    // Try to load from cache first
    if (!forceRefresh) {
      final cachedData = StorageService().getCachedData<Map<String, dynamic>>(
        DBKeys.statsCacheKey,
        maxAge: const Duration(minutes: 5), // Stats cache valid for 5 minutes (more frequent updates)
      );
      
      if (cachedData != null) {
        final stats = StatsModel.fromJson(cachedData);
        emit(state.copyWith(stats: stats, apiStatus: ApiStatus.success));
        
        // Restart timers for upcoming contests
        _setupTimersForUpcomingContests(stats);
        return;
      }
    }

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
          
          // Setup timers for upcoming contests
          _setupTimersForUpcomingContests(r);
          
          final stats = StatsModel.fromJson(r.toJson());
          
          // Cache the data
          StorageService().setCachedData(DBKeys.statsCacheKey, stats.toJson());
          emit(state.copyWith(stats: stats, apiStatus: ApiStatus.success));
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _setupTimersForUpcomingContests(dynamic data) {
    if (data.upcoming?.isNotEmpty ?? false) {
      for (final contest in data.upcoming!) {
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
  }
}
