import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';


part 'elderly_data_event.dart';
part 'elderly_data_state.dart';

class ElderlyDataBloc extends Bloc<ElderlyDataEvent, ElderlyDataState> {
  ElderlyDataBloc() : super(InitialState()) {
    on<SaveElderlyDataToLocalDB> (_saveElderlyDataToLocalDB);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveElderlyDataToLocalDB(SaveElderlyDataToLocalDB event, Emitter<ElderlyDataState> emit) async {

    emit(LoadingState());

    try {

      List<Map<String, dynamic>> letterSizeData = [];
      if (event.titleSize != 0 && event.textSize != 0) {
        // Create a map of letter size to be inserted into the database
        Map<String, dynamic> letterSize = {
          DatabaseHelper.titleSize: event.titleSize,
          DatabaseHelper.textSize: event.textSize,
        };
        letterSizeData.add(letterSize);
      }

      // Create a list to store the contacts for insertion
      List<Map<String, dynamic>> contactsData = [];

      for (int i = 0; i < event.favoritePhoneContacts.length; i++) {
        if (event.favoritePhoneContacts[i]!.personImage.isNotEmpty && event.favoritePhoneContacts[i] != null) {
          // Convert the Photo object to bytes
          // final Uint8List compressedImage = await FlutterImageCompress.compressWithList(
          //   event.favoritePhoneContacts[i]!.personImage as Uint8List,
          //   minHeight: 200,
          //   minWidth: 200,
          //   quality: 80,
          // );

          // Create a map of contact data to be inserted into the database
          Map<String, dynamic> contactData = {
            DatabaseHelper.personName: event.favoritePhoneContacts[i]?.personName ?? '',
            DatabaseHelper.personImage: event.favoritePhoneContacts[i]?.personImage ?? '', // Save the compressed image bytes
            DatabaseHelper.personPhoneNumber: event.favoritePhoneContacts[i]?.personPhoneNumber,
            DatabaseHelper.whatsapp: event.favoritePhoneContacts[i]!.isWhatsApp? '1': '0',
            DatabaseHelper.voiceCall: event.favoritePhoneContacts[i]!.isVoice? '1':'0',
            DatabaseHelper.videoCall: event.favoritePhoneContacts[i]!.isVideo? '1':'0',
          };
          contactsData.add(contactData);
        }
        else{
          if (event.favoritePhoneContacts[i] != null){
            // Create a map of contact data to be inserted into the database
            Map<String, dynamic> contactData = {
              DatabaseHelper.personName: event.favoritePhoneContacts[i]?.personName ?? '',
              DatabaseHelper.personImage: '',
              DatabaseHelper.personPhoneNumber: event.favoritePhoneContacts[i]?.personPhoneNumber,
              DatabaseHelper.whatsapp: event.favoritePhoneContacts[i]!.isWhatsApp? '1': '0',
              DatabaseHelper.voiceCall: event.favoritePhoneContacts[i]!.isVoice? '1': '0',
              DatabaseHelper.videoCall: event.favoritePhoneContacts[i]!.isVideo? '1': '0',
            };
            contactsData.add(contactData);
          }
        }
      }

      // Create a list to store the emergency contacts for insertion
      List<Map<String, dynamic>> emergencyContactsData = [];

      for (int i = 0; i < event.emergencyPhoneContacts.length; i++) {
        if (event.emergencyPhoneContacts[i]!.personImage.isNotEmpty && event.emergencyPhoneContacts[i] != null) {
          // Convert the Photo object to bytes
          // final Uint8List compressedImage = await FlutterImageCompress.compressWithList(
          //   event.emergencyPhoneContacts[i]!.personImage as Uint8List,
          //   minHeight: 200,
          //   minWidth: 200,
          //   quality: 80,
          // );

          // Create a map of contact data to be inserted into the database
          Map<String, dynamic> contactData = {
            DatabaseHelper.emergencyContactsName: event.emergencyPhoneContacts[i]?.personName ?? '',
            DatabaseHelper.emergencyContactsImage: 'compressedImage', // Save the compressed image bytes
            DatabaseHelper.emergencyContactsPhoneNumber: event.emergencyPhoneContacts[i]?.personPhoneNumber,
          };
          emergencyContactsData.add(contactData);
        }
        else{
          if (event.emergencyPhoneContacts[i] != null){
            // Create a map of contact data to be inserted into the database
            Map<String, dynamic> contactData = {
              DatabaseHelper.emergencyContactsName: event.emergencyPhoneContacts[i]?.personName ?? '',
              DatabaseHelper.emergencyContactsImage: '',
              DatabaseHelper.emergencyContactsPhoneNumber: event.emergencyPhoneContacts[i]?.personPhoneNumber,
            };

            emergencyContactsData.add(contactData);
          }
        }
      }

      List<Map<String, dynamic>> soundData = [];

      // Create a map of contact data to be inserted into the database
      Map<String, dynamic> sound = {
        DatabaseHelper.volume: event.volumeValue,
        DatabaseHelper.isBluetooth: event.bluetoothValue ? '1':'0',
      };

      soundData.add(sound);



      List<Map<String, dynamic>> medicineData = [];

      for (int i = 0; i < event.elderlyMedicineModel.length; i++) {
        if (event.elderlyMedicineModel[i] != null) {
          // Create a map of medicine to be inserted into the database
          Map<String, dynamic> medicines = {
            DatabaseHelper.medicineName: event.elderlyMedicineModel[i]!.medicineName,
            DatabaseHelper.medicineImage: event.elderlyMedicineModel[i]!.medicineImage,
            DatabaseHelper.medicineHour: event.elderlyMedicineModel[i]!.medicineHour,
            DatabaseHelper.medicineMinute: event.elderlyMedicineModel[i]!.medicineMinute,
            DatabaseHelper.medicineTime: event.elderlyMedicineModel[i]!.medicineTime,
            DatabaseHelper.medicineDays: event.elderlyMedicineModel[i]!.medicineDays.join(', '),
          };

          medicineData.add(medicines);
        }
      }

      List<Map<String, dynamic>> leisureData = [];



      for (int i = 0; i < event.elderlyAppModel.length; i++) {
        if (event.elderlyAppModel[i] != null) {
          // Create a map of elderly apps to be inserted into the database
          Map<String, dynamic> leisure = {
            DatabaseHelper.appName: event.elderlyAppModel[i]!.gameName,
            DatabaseHelper.appImage: event.elderlyAppModel[i]!.gameImage,
            DatabaseHelper.appUrl: event.elderlyAppModel[i]!.gameUrl,
          };

          leisureData.add(leisure);
        }
      }

      // final Database db = await DatabaseHelper.instance.database;
      await dbHelper.initDatabase();

      await dbHelper.clearLetterSize();
      // Insert the letter size into the database
      for (Map<String, dynamic> letterSize in letterSizeData) {
        await dbHelper.insertLetterSize(letterSize);
      }

      // await dbHelper.clearContacts();
      // Insert the contacts into the database
      for (Map<String, dynamic> contactData in contactsData) {
        await dbHelper.insertContacts(contactData);
      }

      // await dbHelper.clearEmergencyContacts();
      // Insert the emergency contacts into the database
      for (Map<String, dynamic> emergencyContactsData in emergencyContactsData) {
        await dbHelper.insertEmergencyContacts(emergencyContactsData);
      }

      // await db.delete('sqlite_master');
      // await dbHelper.clearSound();
      // Insert the sound into the database
      for (Map<String, dynamic> sound in soundData) {
        await dbHelper.insertSound(sound);
      }

      // await dbHelper.clearMedicine();
      // Insert the medicine into the database
      for (Map<String, dynamic> medicine in medicineData) {
        await dbHelper.insertMedicine(medicine);
      }

      // await dbHelper.clearLeisure();
      // Insert the apps into the database
      for (Map<String, dynamic> leisure in leisureData) {
        await dbHelper.insertLeisure(leisure);
      }

      emit(DataStoredState());


    } catch (e) {
      emit(ErrorState(error: 'Failed to store elderly data! $e'));
      print(e);
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<ElderlyDataState> emit) async {
    emit (RefreshScreenState());
  }
}