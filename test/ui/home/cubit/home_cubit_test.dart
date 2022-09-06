import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/ui/screens/home/cubit/home_cubit.dart';
import 'package:spacex/ui/screens/home/cubit/home_state.dart';
import 'package:spacex_api/spacex_api.dart';

class MockRocketRepository extends Mock implements RocketRepository {}

void main() {
  group('HomeCubit', () {
    late RocketRepository rocketRepository;

    final rockets = List.generate(
      3,
      (index) => Rocket(
        id: '$index',
        name: 'mock_rocket_name_$index',
        description: 'mock_rocket_description_$index',
        height: const Length(meters: 1, feet: 1),
        diameter: const Length(meters: 1, feet: 1),
        mass: const Mass(kg: 1, lb: 1),
      ),
    );

    setUp(() {
      rocketRepository = MockRocketRepository();

      when(() => rocketRepository.fetchAllRockets())
          .thenAnswer((invocation) async => rockets);
    });

    test('initial state is correct', () {
      expect(
        HomeCubit(rocketRepository: rocketRepository).state,
        equals(const HomeState()),
      );
    });

    group('.fetchAllRockets', () {
      blocTest<HomeCubit, HomeState>(
        'emits state with updated rockets',
        build: () => HomeCubit(rocketRepository: rocketRepository),
        act: (cubit) => cubit.fetchAllRockets(),
        expect: () => [
          const HomeState(homeStatus: HomeStatus.loading),
          HomeState(homeStatus: HomeStatus.success, rockets: rockets)
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emit failure state when repository throws Exception',
        build: () {
          when(() => rocketRepository.fetchAllRockets()).thenThrow(Exception());
          return HomeCubit(rocketRepository: rocketRepository);
        },
        act: (cubit) => cubit.fetchAllRockets(),
        expect: () => [
          const HomeState(homeStatus: HomeStatus.loading),
          const HomeState(homeStatus: HomeStatus.failure),
        ],
      );
    });
  });
}
