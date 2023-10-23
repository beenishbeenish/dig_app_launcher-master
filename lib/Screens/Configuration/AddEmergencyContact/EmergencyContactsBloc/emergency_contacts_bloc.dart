import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/emergency_contacts_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:meta/meta.dart';


part 'emergency_contacts_event.dart';
part 'emergency_contacts_state.dart';

class EmergencyContactsBloc extends Bloc<EmergencyContactsEvent, EmergencyContactsState> {
  EmergencyContactsBloc() : super(InitialState()) {
    on<SaveEmergencyContactsDetailEvent> (_saveEmergencyContactsDetailEvent);
    on<GetAllEmergencyContactsEvent> (_getEmergencyContactsDetailEvent);
    on<DeleteSpecificEmergencyContactEvent> (_deleteSpecificEmergencyContactEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveEmergencyContactsDetailEvent(SaveEmergencyContactsDetailEvent event, Emitter<EmergencyContactsState> emit) async {
    emit(LoadingState());
    try {
      // Create a list to store the contacts for insertion
      List<Map<String, dynamic>> emergencyContactsData = [];

      for (int i = 0; i < event.phoneContacts.length; i++) {
        if (event.contactPhotos[i] != null && event.phoneContacts[i] != null) {
          // Convert the Photo object to bytes
          final Uint8List compressedImage = await FlutterImageCompress.compressWithList(
            event.contactPhotos[i]!.bytes,
            minHeight: 200,
            minWidth: 200,
            quality: 80,
          );

          // Create a map of contact data to be inserted into the database
          Map<String, dynamic> contactData = {
            DatabaseHelper.emergencyContactsName: event.phoneContacts[i]?.fullName ?? '',
            DatabaseHelper.emergencyContactsImage: compressedImage, // Save the compressed image bytes
            DatabaseHelper.emergencyContactsPhoneNumber: event.phoneContacts[i]?.phoneNumber?.number,
          };
          emergencyContactsData.add(contactData);
        }
        else{
          if (event.phoneContacts[i] != null){
            // Create a map of contact data to be inserted into the database
            Map<String, dynamic> contactData = {
              DatabaseHelper.emergencyContactsName: event.phoneContacts[i]?.fullName ?? '',
              DatabaseHelper.emergencyContactsImage: '',
              DatabaseHelper.emergencyContactsPhoneNumber: event.phoneContacts[i]?.phoneNumber?.number,
            };

            emergencyContactsData.add(contactData);
          }
        }
      }

      await dbHelper.clearEmergencyContacts();
      // Insert the contacts into the database
      for (Map<String, dynamic> emergencyContactsData in emergencyContactsData) {
        await dbHelper.insertEmergencyContacts(emergencyContactsData);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store contacts data!'));
    }
  }

  _getEmergencyContactsDetailEvent(GetAllEmergencyContactsEvent event, Emitter<EmergencyContactsState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryAllEmergencyContacts();
      RequestEmergencyContactsDetail emergencyContactsDetail = RequestEmergencyContactsDetail.fromJson(data);

      emit (GetAllEmergencyContactsDetailState(emergencyContactsDetail: emergencyContactsDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch emergency contacts data! $e'));
    }
  }

  void _deleteSpecificEmergencyContactEvent(DeleteSpecificEmergencyContactEvent event, Emitter<EmergencyContactsState> emit) async {
    emit(LoadingState());
    try {
      RequestEmergencyContactsDetail? emergencyContactsDetail = event.emergencyContactDetail;

      if (emergencyContactsDetail.emergencyContactsDetailList != null) {
        await dbHelper.deleteEmergencyContact(event.index);
        emit(DataStoredState());
      }
      else {
        emit(ErrorState(error: 'Invalid contact detail!'));
      }
    } catch (e) {
      emit(ErrorState(error: 'Failed to delete contact! $e'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<EmergencyContactsState> emit) async {
    emit (RefreshScreenState());
  }
}