part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {}

class InitialState extends ContactsState {}

class LoadingState extends ContactsState {}

class RefreshScreenState extends ContactsState {}

class DataStoredState extends ContactsState {}

class ErrorState extends ContactsState {
  final String error;
  ErrorState({required this.error});
}

class SaveContactState extends ContactsState {}

class UploadContactState extends ContactsState{
  UploadContactState();
}

class GetAllContactsDetailState extends ContactsState {
  final RequestContactsDetail contactsDetail;
  GetAllContactsDetailState({required this.contactsDetail});       // this.calories
}

class ProductClickAddedToLocalDBState extends ContactsState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends ContactsState {
  final String error;
  InternetErrorState({required this.error});
}