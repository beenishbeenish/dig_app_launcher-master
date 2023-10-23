class AddEmergencyContactRequest {
  AddEmergencyContactRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  AddEmergencyContactRequest.fromJson(Map<String, dynamic> json){
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
    required this.personName,
    required this.personImage,
    required this.personPhoneNumber,
    required this.elderlyId,
    required this.id,
  });
  late final String personName;
  late final String personImage;
  late final String personPhoneNumber;
  late final String elderlyId;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    personName = json['personName'];
    personImage = json['personImage'];
    personPhoneNumber = json['personPhoneNumber'];
    elderlyId = json['elderlyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['personName'] = personName;
    _data['personImage'] = personImage;
    _data['personPhoneNumber'] = personPhoneNumber;
    _data['elderlyId'] = elderlyId;
    _data['id'] = id;
    return _data;
  }
}