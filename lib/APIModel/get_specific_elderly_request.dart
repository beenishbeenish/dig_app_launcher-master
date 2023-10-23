class GetSpecificElderlyRequest {
  GetSpecificElderlyRequest({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final ElderlyDataModel data;

  GetSpecificElderlyRequest.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = ElderlyDataModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class ElderlyDataModel {
  ElderlyDataModel({
    required this.userFullName,
    required this.userEmail,
    required this.userRole,
    required this.isActive,
    required this.verified,
    required this.isAccepted,
    required this.administrator,
    required this.userTitleSize,
    required this.id,
    required this.userTextSize,
    required this.userVolume,
    required this.userBluetooth,
    required this.elderlyMedicine,
    required this.elderlyEmergencyContacts,
    required this.elderlyFavoritesContacts,
    required this.elderlyGame,
  });
  late final String userFullName;
  late final String userEmail;
  late final String userRole;
  late final bool isActive;
  late final bool verified;
  late final bool isAccepted;
  late final String administrator;
  late final int userTitleSize;
  late final String id;
  late final int userTextSize;
  late final int userVolume;
  late final bool userBluetooth;
  late final List<ElderlyMedicineModel> elderlyMedicine;
  late final List<ElderlyEmergencyContacts> elderlyEmergencyContacts;
  late final List<FavoriteContactModel> elderlyFavoritesContacts;
  late final List<ElderlyAppModel> elderlyGame;

  ElderlyDataModel.fromJson(Map<String, dynamic> json){
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    userRole = json['userRole'];
    isActive = json['isActive'];
    verified = json['verified'];
    isAccepted = json['isAccepted'];
    administrator = json['administrator'] ?? '';
    int titleSize = json['userTitleSize'];
    if (titleSize<12) {
      userTitleSize = 22;
    }
    else if(titleSize>40) {
      userTitleSize = 40;
    }
    else {
      userTitleSize = json['userTitleSize'];
    }
    id = json['id'];
    int textSize = json['userTextSize'];
    if (textSize<12) {
      userTextSize = 16;
    }
    else if(textSize>24) {
      userTextSize = 24;
    }
    else {
      userTextSize = json['userTextSize'];
    }
    userVolume = json['userVolume'];
    userBluetooth = json['userBluetooth'];
    elderlyMedicine = List.from(json['elderlyMedicine']).map((e)=>ElderlyMedicineModel.fromJson(e)).toList();
    elderlyEmergencyContacts = List.from(json['elderlyEmergencyContacts']).map((e)=>ElderlyEmergencyContacts.fromJson(e)).toList();
    elderlyFavoritesContacts = List.from(json['elderlyFavoritesContacts']).map((e)=>FavoriteContactModel.fromJson(e)).toList();
    elderlyGame = List.from(json['elderlyGame']).map((e)=>ElderlyAppModel.fromJson(e)).toList();
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
    _data['userTitleSize'] = userTitleSize;
    _data['id'] = id;
    _data['userTextSize'] = userTextSize;
    _data['userVolume'] = userVolume;
    _data['userBluetooth'] = userBluetooth;
    _data['elderlyMedicine'] = elderlyMedicine.map((e)=>e.toJson()).toList();
    _data['elderlyEmergencyContacts'] = elderlyEmergencyContacts.map((e)=>e.toJson()).toList();
    _data['elderlyFavoritesContacts'] = elderlyFavoritesContacts.map((e)=>e.toJson()).toList();
    _data['elderlyGame'] = elderlyGame.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ElderlyMedicineModel {
  ElderlyMedicineModel({
    required this.medicineName,
    required this.medicineImage,
    required this.medicineHour,
    required this.medicineMinute,
    required this.medicineTime,
    required this.medicineDays,
    required this.elderlyId,
    required this.id,
  });
  late final String medicineName;
  late final String medicineImage;
  late final String medicineHour;
  late final String medicineMinute;
  late final String medicineTime;
  late final List<String> medicineDays;
  late final String elderlyId;
  late final String id;

  ElderlyMedicineModel.fromJson(Map<String, dynamic> json){
    medicineName = json['medicineName'];
    medicineImage = json['medicineImage'];
    medicineHour = json['medicineHour'];
    medicineMinute = json['medicineMinute'];
    medicineTime = json['medicineTime'];
    medicineDays = json['medicineDays'];
    elderlyId = json['elderlyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['medicineName'] = medicineName;
    _data['medicineImage'] = medicineImage;
    _data['medicineHour'] = medicineHour;
    _data['medicineMinute'] = medicineMinute;
    _data['medicineTime'] = medicineTime;
    _data['medicineDays'] = medicineDays;
    _data['elderlyId'] = elderlyId;
    _data['id'] = id;
    return _data;
  }
}

class ElderlyEmergencyContacts {
  ElderlyEmergencyContacts({
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

  ElderlyEmergencyContacts.fromJson(Map<String, dynamic> json){
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

class FavoriteContactModel {
  FavoriteContactModel({
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

  FavoriteContactModel.fromJson(Map<String, dynamic> json){
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

class ElderlyAppModel {
  ElderlyAppModel({
    required this.gameName,
    required this.gameImage,
    required this.gameUrl,
    required this.elderlyId,
    required this.id,
  });
  late final String gameName;
  late final String gameImage;
  late final String gameUrl;
  late final String elderlyId;
  late final String id;

  ElderlyAppModel.fromJson(Map<String, dynamic> json){
    gameName = json['gameName'];
    gameImage = json['gameImage'];
    gameUrl = json['gameUrl'];
    elderlyId = json['elderlyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['gameName'] = gameName;
    _data['appImage'] = gameImage;
    _data['gameUrl'] = gameUrl;
    _data['elderlyId'] = elderlyId;
    _data['id'] = id;
    return _data;
  }
}