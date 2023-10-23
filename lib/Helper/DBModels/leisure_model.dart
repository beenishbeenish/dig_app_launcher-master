import 'dart:typed_data';

class RequestAppData {
  List<AppModelLocalDB>? appList;

  RequestAppData({required this.appList});

  RequestAppData.fromJson(List<Map<String, dynamic>> json) {
    appList = <AppModelLocalDB>[];
    for (var v in json) {
      appList!.add(AppModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appList != null) {
      data['AppData'] = appList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppModelLocalDB {
  late final String appName;
  late final Uint8List appImage;
  late final String appUrl;

  AppModelLocalDB({required this.appName, required this.appImage, required this.appUrl});

  AppModelLocalDB.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    appImage = json['appImage'];
    appUrl = json['appUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['appName'] = appName;
    data['appImage'] = appImage;
    data['appUrl'] = appUrl;

    return data;
  }
}