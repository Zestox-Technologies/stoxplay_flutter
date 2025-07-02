part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  List<SectorModel>? sectorList;
  final bool isContestEnabled;

  HomeState({this.sectorList = const [], this.apiStatus = ApiStatus.initial, this.isContestEnabled = false});

  HomeState copyWith({List<SectorModel>? sectorList, ApiStatus? apiStatus, bool? isContestEnabled}) {
    return HomeState(
      sectorList: sectorList ?? this.sectorList,
      apiStatus: apiStatus ?? this.apiStatus,
      isContestEnabled: isContestEnabled ?? this.isContestEnabled,
    );
  }

  @override
  List<Object?> get props => [sectorList, apiStatus, isContestEnabled];
}
