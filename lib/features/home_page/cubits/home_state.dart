part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  List<SectorModel>? sectorList;
  List<ContestModel>? contestList;
  final bool isContestEnabled;

  HomeState({
    this.sectorList = const [],
    this.apiStatus = ApiStatus.initial,
    this.isContestEnabled = false,
    this.contestList = const [],
  });

  HomeState copyWith({
    List<SectorModel>? sectorList,
    List<ContestModel>? contestList,
    ApiStatus? apiStatus,
    bool? isContestEnabled,
  }) {
    return HomeState(
      sectorList: sectorList ?? this.sectorList,
      apiStatus: apiStatus ?? this.apiStatus,
      isContestEnabled: isContestEnabled ?? this.isContestEnabled,
      contestList: contestList ?? this.contestList,
    );
  }

  @override
  List<Object?> get props => [sectorList, apiStatus, isContestEnabled, contestList];
}
