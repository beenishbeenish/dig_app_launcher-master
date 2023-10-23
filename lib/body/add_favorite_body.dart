import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';

class AddFavoriteBody {
  AddFavoriteBody({
    required this.elderlyId,
    required this.favoritesContacts,
  });
  late final String elderlyId;
  late final List<FavoriteContactModel> favoritesContacts;

  AddFavoriteBody.fromJson(Map<String, dynamic> json){
    elderlyId = json['elderlyId'];
    favoritesContacts = List.from(json['favoritesContacts']).map((e)=>FavoriteContactModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['elderlyId'] = elderlyId;
    _data['favoritesContacts'] = favoritesContacts.map((e)=>e.toJson()).toList();
    return _data;
  }
}