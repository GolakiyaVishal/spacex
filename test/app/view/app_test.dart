import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/app/app.dart';
import 'package:spacex/ui/screens/home/view/home_screen.dart';
import 'package:spacex_api/spacex_api.dart';

class MockRocketRepository extends Mock implements RocketRepository {}

void main() {
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

  group('App', () {
    testWidgets('renders AppView', (widgetTester) async {
      await widgetTester.pumpWidget(App(rocketRepository: rocketRepository));

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders HomeScreen', (widgetTester) async {
      await widgetTester.pumpWidget(App(rocketRepository: rocketRepository));

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
