import 'dart:math';

import 'package:spacex_api/src/models/rocket.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Rocket', () {
    const rocket = Rocket(
      id: '1',
      name: 'mock-rocket-name-1',
      description: 'description',
      height: Length(meters: 1, feet: 1),
      diameter: Length(meters: 1, feet: 1),
      mass: Mass(kg: 1, lb: 1),
    );

    test('support value comparisons', () {
      expect(
        rocket,
        const Rocket(
          id: '1',
          name: 'mock-rocket-name-1',
          description: 'description',
          height: Length(meters: 1, feet: 1),
          diameter: Length(meters: 1, feet: 1),
          mass: Mass(kg: 1, lb: 1),
        ),
      );
    });

    test('has concise toString', () {
      expect(rocket.toString(), 'Rocket(1, mock-rocket-name-1)');
    });
  });

  group('Length', (){

    const length = Length(meters: 1, feet: 1);

    test('support value comparison', (){
      expect(length, const Length(meters: 1, feet: 1));
    });

    test('has concise toString', (){
      expect(length.toString(), 'Length(1.0 m, 1.0 ft)');
    });
  });

  group('Mass', (){

    const mass = Mass(kg: 1, lb: 1);

    test('support value comparison', (){
      expect(mass, const Mass(kg: 1, lb: 1));
    });

    test('has concise toString', (){
      expect(mass.toString(), 'Mass(1.0 kg, 1.0 lb)');
    });
  });
}
