import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/ui/screens/home/cubit/home_cubit.dart';
import 'package:spacex/ui/screens/home/cubit/home_state.dart';
import 'package:spacex/ui/screens/home/view/home_screen.dart';
import 'package:spacex_api/spacex_api.dart';

import '../../../helpers/helpers.dart';

class MockRocketRepository extends Mock implements RocketRepository {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
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

  group('HomeScreen', () {
    late RocketRepository rocketRepository;

    setUp(() {
      rocketRepository = MockRocketRepository();
      when(() => rocketRepository.fetchAllRockets())
          .thenAnswer((invocation) async => rockets);
    });

    testWidgets('render HomeView', (widgetTester) async {
      await widgetTester.pumpApp(
        const HomeScreen(),
        rocketRepository: rocketRepository,
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeCubit homeCubit;

    setUp(() {
      homeCubit = MockHomeCubit();
    });

    setUpAll(() {
      registerFallbackValue(const HomeState());
    });

    testWidgets(
      'renders empty page when status is initial',
      (widgetTester) async {
        // const key = Key('homeView_initial_sizedBox');
        // const key = Key('homeView_loading_progressIndicator');
        const key = Key('homeView_success_rocketList');

        await widgetTester.pumpApp(
          BlocProvider.value(
            value: homeCubit,
            child: const HomeScreen(),
          ),
        );

        expect(find.byKey(key), findsOneWidget);
      },
    );

    testWidgets('renders loader when status is loading', (widgetTester) async {
      const key = Key('homeView_loading_progressIndicator');

      when(() => homeCubit.state)
          .thenReturn(const HomeState(homeStatus: HomeStatus.loading));

      await widgetTester.pumpApp(
        BlocProvider.value(
          value: homeCubit,
          child: const HomeView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets(
      'renders error text when status is failure',
      (widgetTester) async {
        const key = Key('homeView_failure_error_text');

        when(() => homeCubit.state)
            .thenReturn(const HomeState(homeStatus: HomeStatus.failure));

        await widgetTester.pumpApp(
          BlocProvider.value(
            value: homeCubit,
            child: const HomeView(),
          ),
        );

        expect(find.byKey(key), findsOneWidget);
      },
    );

    testWidgets(
      'renders rocket list when status is success',
      (widgetTester) async {
        const key = Key('homeView_success_rocketList');

        when(() => homeCubit.state).thenReturn(
          HomeState(homeStatus: HomeStatus.success, rockets: rockets),
        );

        await widgetTester.pumpApp(
          BlocProvider.value(
            value: homeCubit,
            child: const HomeView(),
          ),
        );

        expect(find.byKey(key), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(rockets.length));
      },
    );
  });
}
