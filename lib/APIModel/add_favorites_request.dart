class AddFavoritesRequest {
  AddFavoritesRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  AddFavoritesRequest.fromJson(Map<String, dynamic> json){
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
    required this.personName,
    required this.personImage,
    required this.personPhoneNumber,
    required this.isVideo,
    required this.isVoice,
    required this.isWhatsApp,
    required this.elderlyId,
    required this.id,
  });
  late final String personName;
  late final String personImage;
  late final String personPhoneNumber;
  late final bool isVideo;
  late final bool isVoice;
  late final bool isWhatsApp;
  late final String elderlyId;
  late final String id;

  Data.fromJson(Map<String, dynamic> json){
    personName = json['personName'];
    personImage = json['personImage'];
    personPhoneNumber = json['personPhoneNumber'];
    isVideo = json['isVideo'];
    isVoice = json['isVoice'];
    isWhatsApp = json['isWhatsApp'];
    elderlyId = json['elderlyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['personName'] = personName;
    _data['personImage'] = personImage;
    _data['personPhoneNumber'] = personPhoneNumber;
    _data['isVideo'] = isVideo;
    _data['isVoice'] = isVoice;
    _data['isWhatsApp'] = isWhatsApp;
    _data['elderlyId'] = elderlyId;
    _data['id'] = id;
    return _data;
  }
}