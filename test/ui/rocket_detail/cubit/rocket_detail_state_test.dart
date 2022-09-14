import 'package:flutter_test/flutter_test.dart';
import 'package:spacex/ui/screens/rocket_detail/cubit/rocket_detail_state.dart';
import 'package:spacex_api/spacex_api.dart';

void main() {
  group('RocketDescriptionState', () {
    const rocket = Rocket(
      id: '1',
      name: 'mock_rocket_name_1',
      description: 'mock_rocket_description_1',
      height: Length(meters: 1, feet: 1),
      diameter: Length(meters: 1, feet: 1),
      mass: Mass(kg: 1, lb: 1),
    );

    test('supports value comparison', () {
      expect(
        const RocketDetailState(rocket: rocket),
        const RocketDetailState(rocket: rocket),
      );
    });
  });
}
