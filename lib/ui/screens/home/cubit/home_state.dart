import 'package:equatable/equatable.dart';
import 'package:spacex_api/spacex_api.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.homeStatus = HomeStatus.initial,
    this.rockets = const [],});


  final HomeStatus homeStatus;
  final List<Rocket> rockets;

  HomeState copyWith({HomeStatus? homeStatus, List<Rocket>? rockets}){
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      rockets: rockets ?? this.rockets,
    );
  }

  @override
  List<Object> get props => [homeStatus, rockets];
}
