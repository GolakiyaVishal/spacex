import 'package:spacex_api/spacex_api.dart';

/// Throws when an error occurs while looking up for rockets.
class RocketException implements Exception {}

/// Thrown when an error occurs while searching rocket
class SearchException implements Exception {}

/// {@template rocket_repository}
/// A Dart class to expose method to access rocket-related functionality.
/// {@endtemplate}
class RocketRepository {
  /// {@macro rocket_repository}
  RocketRepository({SpacexApiClient? spacexApiClient})
      : _spacexApiClient = spacexApiClient ?? SpacexApiClient();

  final SpacexApiClient _spacexApiClient;

  /// Return all rockets at spacex.
  ///
  /// Throw [RocketException] if error occurs.
  Future<List<Rocket>> fetchAllRockets() {
    try {
      return _spacexApiClient.fetchAllRocket();
    } on Exception {
      throw RocketException();
    }
  }
}
