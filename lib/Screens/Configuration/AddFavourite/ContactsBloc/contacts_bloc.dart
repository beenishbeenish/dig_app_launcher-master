import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:meta/meta.dart';

import '../../../../APIModel/get_specific_elderly_request.dart';


part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(InitialState()) {
    on<SaveContactsDetailEvent> (_saveContactsDetailEvent);
    on<GetAllContactsEvent> (_getContactsDetailEvent);
    on<DeleteSpecificContactEvent> (_deleteSpecificContactEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveContactsDetailEvent(SaveContactsDetailEvent event, Emitter<ContactsState> emit) async {
    emit(LoadingState());
    try {
      // Create a list to store the contacts for insertion
      List<Map<String, dynamic>> contactsData = [];

      for (int i = 0; i < event.phoneContacts.length; i++) {
        if (event.phoneContacts[i].personImage != null && event.phoneContacts[i] != null) {
          // Convert the Photo object to bytes


          // Create a map of contact data to be inserted into the database
          Map<String, dynamic> contactData = {
            DatabaseHelper.personName: event.phoneContacts[i].personName ?? '',
            DatabaseHelper.personImage: event.phoneContacts[i].personImage ?? '', // Save the compressed image bytes
            DatabaseHelper.personPhoneNumber: event.phoneContacts[i].personPhoneNumber,
            DatabaseHelper.whatsapp: event.phoneContacts[i].isWhatsApp? '1':'0',
            DatabaseHelper.voiceCall: event.phoneContacts[i].isVoice ? '1':'0',
            DatabaseHelper.videoCall: event.phoneContacts[i].isVideo ? '1': '0',
          };
          contactsData.add(contactData);
        }
        else{
          if (event.phoneContacts[i] != null){
            // Create a map of contact data to be inserted into the database
            Map<String, dynamic> contactData = {
              DatabaseHelper.personName: event.phoneContacts[i].personName ?? '',
              DatabaseHelper.personImage: event.phoneContacts[i].personImage,
              DatabaseHelper.personPhoneNumber: event.phoneContacts[i].personPhoneNumber,
              DatabaseHelper.whatsapp: event.phoneContacts[i].isWhatsApp? '1':'0',
              DatabaseHelper.voiceCall: event.phoneContacts[i].isVoice ? '1':'0',
              DatabaseHelper.videoCall: event.phoneContacts[i].isVideo ? '1': '0',
            };
            contactsData.add(contactData);
          }
        }
      }

      await dbHelper.clearContacts();
      // Insert the contacts into the database
      for (Map<String, dynamic> contactData in contactsData) {
        await dbHelper.insertContacts(contactData);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store contacts data!'));
    }
  }


  _getContactsDetailEvent(GetAllContactsEvent event, Emitter<ContactsState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryAllContacts();
      RequestContactsDetail contactsDetail = RequestContactsDetail.fromJson(data);

      emit (GetAllContactsDetailState(contactsDetail: contactsDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch contacts data! $e'));
    }
  }

  void _deleteSpecificContactEvent(DeleteSpecificContactEvent event, Emitter<ContactsState> emit) async {
    emit(LoadingState());
    try {
      RequestContactsDetail? contactsDetail = event.contactDetail;

      if (contactsDetail.contactsDetailList != null) {
        await dbHelper.deleteFavoriteContact(event.index);
        emit(DataStoredState());
      }
      else {
        emit(ErrorState(error: 'Invalid contact detail!'));
      }
    } catch (e) {
      emit(ErrorState(error: 'Failed to delete contact!'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<ContactsState> emit) async {
    emit (RefreshScreenState());
  }
}