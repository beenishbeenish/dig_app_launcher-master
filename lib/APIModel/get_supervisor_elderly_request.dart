class GetSupervisorElderlyRequest {
  GetSupervisorElderlyRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  GetSupervisorElderlyRequest.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.userEmail,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.userFullName,
    required this.id,
    required this.supervisorElderly,
  });
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String userFullName;
  late final String id;
  late final List<SupervisorElderly> supervisorElderly;

  Data.fromJson(Map<String, dynamic> json){
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    userFullName = json['userFullName'];
    id = json['id'];
    supervisorElderly = List.from(json['supervisorElderly']).map((e)=>SupervisorElderly.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userEmail'] = userEmail;
    _data['userRole'] = userRole;
    _data['isActive'] = isActive;
    _data['verified'] = verified;
    _data['isAccepted'] = isAccepted;
    _data['userFullName'] = userFullName;
    _data['id'] = id;
    _data['supervisorElderly'] = supervisorElderly.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SupervisorElderly {
  SupervisorElderly({
    required this.userFullName,
    required this.userEmail,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.userTextSize,
    required this.userTitleSize,
    required this.userBluetooth,
    required this.userVolume,
    required this.id,
  });
  late final String userFullName;
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final int userTextSize;
  late final int userTitleSize;
  late final bool userBluetooth;
  late final int userVolume;
  late final String id;

  SupervisorElderly.fromJson(Map<String, dynamic> json){
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    userTextSize = json['userTextSize'];
    userTitleSize = json['userTitleSize'];
    userBluetooth = json['userBluetooth'];
    userVolume = json['userVolume'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userFullName'] = userFullName;
    _data['userEmail'] = userEmail;
    _data['userRole'] = userRole;
    _data['isActive'] = isActive;
    _data['verified'] = verified;
    _data['isAccepted'] = isAccepted;
    _data['userTextSize'] = userTextSize;
    _data['userTitleSize'] = userTitleSize;
    _data['userBluetooth'] = userBluetooth;
    _data['userVolume'] = userVolume;
    _data['id'] = id;
    return _data;
  }
}