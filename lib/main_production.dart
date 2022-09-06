import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/app/app.dart';
import 'package:spacex/bootstrap.dart';

void main() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final rocketRepository = RocketRepository();

  runZonedGuarded(
      () => bootstrap(
            () => App(
              rocketRepository: rocketRepository,
            ),
          ), (error, stack) {
    log(error.toString(), stackTrace: stack);
  });
}
