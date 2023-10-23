class SignUpRequest {
  SignUpRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  SignUpRequest.fromJson(Map<String, dynamic> json){
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
    required this.isActive,
    required this.verified,
    required this.isAccepted,
  });
  late final String id;
  late final String userFullName;
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userFullName'] = userFullName;
    _data['userEmail'] = userEmail;
    _data['userRole'] = userRole;
    _data['isActive'] = isActive;
    _data['verified'] = verified;
    _data['isAccepted'] = isAccepted;
    return _data;
  }
}