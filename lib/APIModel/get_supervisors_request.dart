class GetSupervisorsRequest {
  GetSupervisorsRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  GetSupervisorsRequest.fromJson(Map<String, dynamic> json){
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
    required this.supervisor,
  });
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String userFullName;
  late final String id;
  late final List<Supervisor> supervisor;

  Data.fromJson(Map<String, dynamic> json){
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    userFullName = json['userFullName'];
    id = json['id'];
    supervisor = List.from(json['supervisor']).map((e)=>Supervisor.fromJson(e)).toList();
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
    _data['supervisor'] = supervisor.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Supervisor {
  Supervisor({
    this.userFullName,
    required this.userEmail,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.id,
  });
  late final Null userFullName;
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String id;

  Supervisor.fromJson(Map<String, dynamic> json){
    userFullName = null;
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
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
    _data['id'] = id;
    return _data;
  }
}