import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:spacex/ui/screens/rocket_detail/cubit/rocket_detail_state.dart';
import 'package:spacex/ui/screens/rocket_detail/rocket_detail.dart';
import 'package:spacex_api/spacex_api.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../helpers/helpers.dart';

class MockRocketDetailCubit extends Mock implements RocketDetailCubit {}

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late RocketDetailCubit rocketDetailCubit;
  late UrlLauncherPlatform urlLauncherPlatform;

  final rocket = Rocket(
    id: '1',
    name: 'mock_rocket_name_1',
    description: 'mock_rocket_description_1',
    height: const Length(meters: 1, feet: 1),
    diameter: const Length(meters: 1, feet: 1),
    mass: const Mass(kg: 1, lb: 1),
    flickrImages: const ['https://picsum.photos/200'],
    active: true,
    firstFlight: DateTime(2021, 12, 31),
    wikipedia: 'https://wikipedia.com/',
  );

  setUp(() {
    rocketDetailCubit = MockRocketDetailCubit();
    when(() => rocketDetailCubit.state)
        .thenReturn(RocketDetailState(rocket: rocket));

    urlLauncherPlatform = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = urlLauncherPlatform;
    when(() => urlLauncherPlatform.canLaunch(any()))
        .thenAnswer((invocation) async => true);
    when(() => urlLauncherPlatform.launchUrl(any(), const LaunchOptions()))
        .thenAnswer((invocation) async => true);
  });

  setUpAll(() {
    registerFallbackValue(RocketDetailState(rocket: rocket));
  });

  group('RocketDetailScreen', () {
    test('rocket detail screen has route', () {
      expect(
        RocketDetailScreen.route(rocket: rocket),
        isA<MaterialPageRoute<void>>(),
      );
    });

    testWidgets('renders RocketDetailView', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpApp(
          Navigator(
            onGenerateRoute: (_) => RocketDetailScreen.route(rocket: rocket),
          ),
        );
      });

      expect(find.byType(RocketDetailView), findsOneWidget);
    });
  });

  group('RocketDetailView', () {
    testWidgets('render first flicker image if available',
        (widgetTester) async {
      const key = Key('rocketDetailScreen_imageHeader');

      when(() => rocketDetailCubit.state)
          .thenReturn(RocketDetailState(rocket: rocket));

      await mockNetworkImages(() async {
        await widgetTester.pumpApp(
          BlocProvider.value(
            value: rocketDetailCubit,
            child: const RocketDetailView(),
          ),
        );
      });

      expect(find.byKey(key), findsOneWidget);
    });
    
    group('title header', () {
      testWidgets('render rocket title', (widgetTester) async {

      });
    });
    
  });

  // renders first flicker image

  // renders rocket title
  // renders check icon when rocket is active
  // renders cross icon when rocket is inactive

  // renders first launch date
  // renders description

  //
  // is render when url is available
  // is not render when url is not available
  // attempt to open wikipedia url
}
