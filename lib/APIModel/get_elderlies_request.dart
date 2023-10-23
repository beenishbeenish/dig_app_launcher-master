class GetElderlyRequest {
  GetElderlyRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  GetElderlyRequest.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.userEmail,
    required this.userToken,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.userFullName,
    required this.elderly,
  });
  late final String id;
  late final String userEmail;
  late final String userToken;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String userFullName;
  late final List<Elderly> elderly;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userEmail = json['userEmail'];
    userToken = json['userToken'] ?? '';
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    userFullName = json['userFullName'];
    elderly = List.from(json['elderly']).map((e)=>Elderly.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userEmail'] = userEmail;
    _data['userToken'] = userToken;
    _data['userRole'] = userRole;
    _data['isActive'] = isActive;
    _data['verified'] = verified;
    _data['isAccepted'] = isAccepted;
    _data['userFullName'] = userFullName;
    _data['elderly'] = elderly.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Elderly {
  Elderly({
    required this.userFullName,
    required this.userEmail,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.administrator,
    required this.id,
  });
  late final String userFullName;
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String administrator;
  late final String id;

  Elderly.fromJson(Map<String, dynamic> json){
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    administrator = json['administrator'];
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
    _data['administrator'] = administrator;
    _data['id'] = id;
    return _data;
  }
}