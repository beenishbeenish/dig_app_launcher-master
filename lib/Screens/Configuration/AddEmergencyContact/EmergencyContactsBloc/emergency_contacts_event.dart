part of 'emergency_contacts_bloc.dart';

abstract class EmergencyContactsEvent {}

//Save Emergency Contact
class SaveEmergencyContactsDetailEvent extends EmergencyContactsEvent {
  final List<PhoneContact?> phoneContacts;
  final List<Photo?> contactPhotos;

  SaveEmergencyContactsDetailEvent(this.phoneContacts, this.contactPhotos);
}

//Fetch Emergency Contacts
class GetAllEmergencyContactsEvent extends EmergencyContactsEvent {
  GetAllEmergencyContactsEvent();
}

//Delete Emergency Contact
class DeleteSpecificEmergencyContactEvent extends EmergencyContactsEvent {

  RequestEmergencyContactsDetail emergencyContactDetail;
  int index;
  DeleteSpecificEmergencyContactEvent({required this.emergencyContactDetail, required this.index});
}

class RefreshScreenEvent extends EmergencyContactsEvent {
  RefreshScreenEvent();
}