import 'package:bloc/bloc.dart';
import 'package:spacex_api/spacex_api.dart';

import 'rocket_detail_state.dart';

class RocketDetailCubit extends Cubit<RocketDetailState> {
  RocketDetailCubit({required Rocket rocket})
      : super(RocketDetailState(rocket: rocket));
}
