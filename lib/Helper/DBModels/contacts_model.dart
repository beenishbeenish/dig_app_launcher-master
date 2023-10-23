import 'dart:typed_data';

class RequestContactsDetail {
  List<ContactsDetailModelLocalDB>? contactsDetailList;

  RequestContactsDetail({required this.contactsDetailList});

  RequestContactsDetail.fromJson(List<Map<String, dynamic>> json) {
    contactsDetailList = <ContactsDetailModelLocalDB>[];
    for (var v in json) {
      contactsDetailList!.add(ContactsDetailModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contactsDetailList != null) {
      data['ContactsDetailData'] = contactsDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactsDetailModelLocalDB {
  late final String personName;
  late final Uint8List? personImage;
  late final String personPhoneNumber;
  late final String whatsapp;
  late final String voiceCall;
  late final String videoCall;

  ContactsDetailModelLocalDB({required this.personName, this.personImage, required this.personPhoneNumber, required this.whatsapp, required this.voiceCall, required this.videoCall});

  ContactsDetailModelLocalDB.fromJson(Map<String, dynamic> json) {
    personName = json['personName'];
    var mPersonImage = json['personImage'];
    if (mPersonImage != null && mPersonImage is! String){
      personImage = json['personImage'];
    }else{
      personImage = null;
    }
    personPhoneNumber = json['personPhoneNumber'];
    whatsapp = json['whatsapp'];
    voiceCall = json['voiceCall'];
    videoCall = json['videoCall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['personName'] = personName;
    data['personImage'] = personImage;
    data['personPhoneNumber'] = personPhoneNumber;
    data['whatsapp'] = whatsapp;
    data['voiceCall'] = voiceCall;
    data['videoCall'] = videoCall;

    return data;
  }
}
