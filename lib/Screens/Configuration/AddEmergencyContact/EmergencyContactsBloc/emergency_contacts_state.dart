part of 'emergency_contacts_bloc.dart';

@immutable
abstract class EmergencyContactsState {}

class InitialState extends EmergencyContactsState {}

class LoadingState extends EmergencyContactsState {}

class RefreshScreenState extends EmergencyContactsState {}

class DataStoredState extends EmergencyContactsState {}

class ErrorState extends EmergencyContactsState {
  final String error;
  ErrorState({required this.error});
}

class SaveEmergencyContactState extends EmergencyContactsState {}

class GetAllEmergencyContactsDetailState extends EmergencyContactsState {
  final RequestEmergencyContactsDetail emergencyContactsDetail;
  GetAllEmergencyContactsDetailState({required this.emergencyContactsDetail});       // this.calories
}

class ProductClickAddedToLocalDBState extends EmergencyContactsState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends EmergencyContactsState {
  final String error;
  InternetErrorState({required this.error});
}