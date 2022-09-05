import 'package:mocktail/mocktail.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex_api/spacex_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockSpaceXApiClient extends Mock implements SpacexApiClient {}

void main() {
  group('RocketRepository', () {
    late RocketRepository rocketRepository;
    late SpacexApiClient spacexApiClient;

    final rockets = List.generate(
        3,
        (index) => Rocket(
            id: '$index',
            name: 'mock_rocket_name_$index',
            description: 'mock_rocket_description_$index',
            height: const Length(meters: 1, feet: 1),
            diameter: const Length(meters: 1, feet: 1),
            mass: const Mass(kg: 1, lb: 1)));

    setUp(() {
      spacexApiClient = MockSpaceXApiClient();
      rocketRepository = RocketRepository(spacexApiClient: spacexApiClient);

      when(() => spacexApiClient.fetchAllRocket())
          .thenAnswer((invocation) async => rockets);
    });

    test('constructor returns normally', () {
      expect(RocketRepository.new, returnsNormally);
    });

    group('.fetchAllRocket', () {
      test('throw RocketException when api throws Exception', (){
        when(() => spacexApiClient.fetchAllRocket()).thenThrow(Exception());

        expect(() => rocketRepository.fetchAllRockets(), throwsA(isA<RocketException>()));

        verify(() => spacexApiClient.fetchAllRocket()).called(1);
      });

      test('make correct request', () async {
        await rocketRepository.fetchAllRockets();

        verify(() => spacexApiClient.fetchAllRocket()).called(1);
      });
    });
  });
}
