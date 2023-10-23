class SendInstalledAppRequest {
  SendInstalledAppRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  SendInstalledAppRequest.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.appName,
    required this.appImage,
    required this.elderlyId,
    required this.id,
  });
  late final String appName;
  late final String appImage;
  late final String elderlyId;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    appName = json['appName'];
    appImage = json['appImage'];
    elderlyId = json['elderlyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['appName'] = appName;
    _data['appImage'] = appImage;
    _data['elderlyId'] = elderlyId;
    _data['id'] = id;
    return _data;
  }
}