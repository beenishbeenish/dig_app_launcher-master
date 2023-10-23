part of 'contacts_bloc.dart';

abstract class ContactsEvent {}

//Save Favorites Contact
class SaveContactsDetailEvent extends ContactsEvent {
  final List<FavoriteContactModel> phoneContacts;

  SaveContactsDetailEvent(this.phoneContacts);
}

//Fetch Favorites Contact
class GetAllContactsEvent extends ContactsEvent {
  GetAllContactsEvent();
}

//Delete Favorite Contact
class DeleteSpecificContactEvent extends ContactsEvent {

  RequestContactsDetail contactDetail;
  int index;
  DeleteSpecificContactEvent({required this.contactDetail, required this.index});
}

class RefreshScreenEvent extends ContactsEvent {
  RefreshScreenEvent();
}
