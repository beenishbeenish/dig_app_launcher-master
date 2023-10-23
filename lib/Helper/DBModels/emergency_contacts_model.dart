import 'dart:typed_data';

class RequestEmergencyContactsDetail {
  List<EmergencyContactsDetailModelLocalDB>? emergencyContactsDetailList;

  RequestEmergencyContactsDetail({required this.emergencyContactsDetailList});

  RequestEmergencyContactsDetail.fromJson(List<Map<String, dynamic>> json) {
    emergencyContactsDetailList = <EmergencyContactsDetailModelLocalDB>[];
    for (var v in json) {
      emergencyContactsDetailList!.add(EmergencyContactsDetailModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (emergencyContactsDetailList != null) {
      data['EmergencyContactsDetailData'] = emergencyContactsDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmergencyContactsDetailModelLocalDB {
  late final String personName;
  late final Uint8List? personImage;
  late final String personPhoneNumber;

  EmergencyContactsDetailModelLocalDB({required this.personName, this.personImage, required this.personPhoneNumber});

  EmergencyContactsDetailModelLocalDB.fromJson(Map<String, dynamic> json) {
    personName = json['emergencyContactsName'];
    var mPersonImage = json['emergencyContactsImage'];
    if (mPersonImage != null && mPersonImage is! String){
      personImage = json['emergencyContactsImage'];
    }else{
      personImage = null;
    }
    personPhoneNumber = json['emergencyContactsPhoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['emergencyContactsName'] = personName;
    data['emergencyContactsImage'] = personImage;
    data['emergencyContactsPhoneNumber'] = personPhoneNumber;

    return data;
  }
}