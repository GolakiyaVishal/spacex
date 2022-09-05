import 'dart:developer';
import 'dart:io';

import 'package:rocket_repository/rocket_repository.dart';

void main() async {
  final RocketRepository rocketRepository = RocketRepository();

  try {
    final rockets = await rocketRepository.fetchAllRockets();
    for (final rocket in rockets) {
      log(rocket.toString());
    }
  } on Exception catch (exception) {
    log(exception.toString());
  }

  exit(0);
}
