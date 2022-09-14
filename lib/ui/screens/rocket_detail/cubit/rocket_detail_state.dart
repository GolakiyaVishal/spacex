import 'package:equatable/equatable.dart';
import 'package:spacex_api/spacex_api.dart';

class RocketDetailState extends Equatable {
  const RocketDetailState({required this.rocket});

  final Rocket rocket;

  @override
  List<Object> get props => [rocket];
}
