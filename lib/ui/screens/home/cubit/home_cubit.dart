import 'package:bloc/bloc.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/ui/screens/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required RocketRepository rocketRepository})
      : _rocketRepository = rocketRepository,
        super(const HomeState());

  final RocketRepository _rocketRepository;

  Future<void> fetchAllRockets() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading));

    try {
      final rockets = await _rocketRepository.fetchAllRockets();
      emit(state.copyWith(homeStatus: HomeStatus.success, rockets: rockets));
    } catch (e) {
      emit(state.copyWith(homeStatus: HomeStatus.failure));
    }
  }
}
