import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_research/home/data/remote_config_home_model.dart';

class FeatureRemoteConfig {
  RemoteConfigHomeModel remoteConfigHomeModel;

  Future<RemoteConfigHomeModel> checkPageRomoteConfigSpecific(
      String type) async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    if (type == 'home_menu') {
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      remoteConfigHomeModel = RemoteConfigHomeModel.fromJson(
          json.decode(remoteConfig.getString('menu')));

      return remoteConfigHomeModel;
    } else {
      return remoteConfigHomeModel;
    }
  }
}
