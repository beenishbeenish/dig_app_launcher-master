import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';

class UploadContactResponse {
  UploadContactResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<FavoriteContactModel> data;

  UploadContactResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>FavoriteContactModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}