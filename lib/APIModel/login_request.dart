class LoginRequest {
  LoginRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  LoginRequest.fromJson(Map<String, dynamic> json){
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
    required this.userFullName,
    required this.userEmail,
    required this.userRole,
    required this.accessToken,
  });
  late final String id;
  late final String userFullName;
  late final String userEmail;
  late final String userRole;
  late final String accessToken;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userFullName'] = userFullName;
    _data['userEmail'] = userEmail;
    _data['userRole'] = userRole;
    _data['accessToken'] = accessToken;
    return _data;
  }
}