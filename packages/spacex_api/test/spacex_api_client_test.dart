import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:spacex_api/spacex_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('SpaceXApiClient', () {
    late http.Client httpClient;
    late SpacexApiClient apiClient;

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
      httpClient = MockHttpClient();
      apiClient = SpacexApiClient(httpClient: httpClient);
    });

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    test('constructor returns normally', () {
      expect(SpacexApiClient.new, returnsNormally);
    });

    group('.fetchAllRockets', () {
      setUp(() {
        when(() => httpClient.get(any())).thenAnswer(
          (invocation) async => http.Response(jsonEncode(rockets), 200),
        );
      });

      test('throws HttpException when http throws Exception', () {
        when(() => httpClient.get(any())).thenThrow(Exception());

        expect(() => apiClient.fetchAllRocket(), throwsA(isA<HttpException>()));
      });

      test('throws HttpRequestFailure exception when response code is not 200',
          () {
        when(() => httpClient.get(any()))
            .thenAnswer((invocation) async => http.Response('', 400));

        expect(
          apiClient.fetchAllRocket(),
          throwsA(
            isA<HttpRequestFailure>()
                .having((error) => error.statusCode, 'statusCode', 400),
          ),
        );
      });

      test('throws JsonDecodeException when decoding response fails', () {
        when(() => httpClient.get(any())).thenAnswer(
          (invocation) async => http.Response('no json format', 200),
        );

        expect(apiClient.fetchAllRocket(), throwsA(isA<JsonDecodeException>()));
      });

      test(
          'throws JsonDeserializationException when '
          'response body json deserialization fails', () {
        when(() => httpClient.get(any())).thenAnswer(
          (invocation) async => http.Response('[{"data": 1}]', 200),
        );
      });

      test('make correct request', () async {
        await apiClient.fetchAllRocket();

        verify(
          () => httpClient
              .get(Uri.http(SpacexApiClient.authority, '/v4/rockets')),
        ).called(1);
      });

      test('return correct list of rockets', () {
        expect(apiClient.fetchAllRocket(), completion(equals(rockets)));
      });
    });
  });
}
