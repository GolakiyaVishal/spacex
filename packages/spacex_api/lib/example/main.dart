import 'dart:developer';
import 'dart:io';

import 'package:spacex_api/spacex_api.dart';


Future<void> main() async {
    final spaceXApiClient = SpacexApiClient();

    try {
      final rockets = await spaceXApiClient.fetchAllRocket();
      for(final rocket in rockets) {
        log(rocket.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }

    exit(0);
}
