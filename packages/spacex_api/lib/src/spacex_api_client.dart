import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:spacex_api/src/models/rocket.dart';

/// Thrown if exception occurs while calling `http` request.
class HttpException implements Exception {}

/// {@template http_request_failure}
/// Thrown if the `http` request returns non 200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  HttpRequestFailure(this.statusCode);

  /// status code of response
  final int statusCode;
}

/// Thrown if the exception occurs while decoding the response body
class JsonDecodeException implements Exception {}

/// Thrown if the exception occurs while deserializing the response body
class JsonDeserializationException implements Exception {}

/// {@template spacex_api_client}
/// A Dart API Client for the spacex REST API.
/// Learn more at https://www.spacex.com/api/
/// {@endtemplate}
class SpacexApiClient {
  /// {@macro spacex_api_client}
  SpacexApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// The host url used for all API request.
  @visibleForTesting
  static const authority = 'api.spacexdata.com';

  /// Fetch all spacex rocket
  ///
  /// REST call: `GET /rockets`
  Future<List<Rocket>> fetchAllRocket() async {
    final url = Uri.http(authority, '/v4/rockets');

    http.Response response;

    try {
      response = await _httpClient.get(url);
    } catch (_) {
      throw HttpException();
    }

    if (200 != response.statusCode) {
      throw HttpRequestFailure(response.statusCode);
    }

    List<dynamic> body;

    try {
      body = jsonDecode(response.body) as List;
    } catch (_) {
      throw JsonDecodeException();
    }

    try {
      return body
          .map((item) => Rocket.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw JsonDecodeException();
    }
  }
}
