import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/leisure_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

part 'leisure_event.dart';
part 'leisure_state.dart';

class LeisureBloc extends Bloc<LeisureEvent, LeisureState> {
  LeisureBloc() : super(InitialState()) {
    on<SaveAppEvent> (_saveAppEvent);
    on<GetAllAppEvent> (_getAllAppEvent);
    on<GetLetterSizeEvent> (_getLetterSizeEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveAppEvent(SaveAppEvent event, Emitter<LeisureState> emit) async {
    emit(LoadingState());
    try {
      List<Map<String, dynamic>> leisureData = [];

      Map<String, dynamic> leisure = {
        DatabaseHelper.appName: event.appName,
        DatabaseHelper.appImage: event.appImage,
        DatabaseHelper.appUrl: event.packageName,
      };

      leisureData.add(leisure);

      await dbHelper.clearLeisure();
      // Insert the contacts into the database
      for (Map<String, dynamic> leisure in leisureData) {
        await dbHelper.insertLeisure(leisure);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store app! $e'));
    }
  }

  _getAllAppEvent(GetAllAppEvent event, Emitter<LeisureState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryAllLeisure();
      RequestAppData leisureData = RequestAppData.fromJson(data);

      emit (GetAllAppState(appDetail: leisureData));
    } catch (e) {
      emit (ErrorState(error: 'No App found!'));
    }
  }

  _getLetterSizeEvent(GetLetterSizeEvent event, Emitter<LeisureState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryLetterSize();
      RequestLetterSizeDetail letterSizeDetail = RequestLetterSizeDetail.fromJson(data);

      emit (GetLetterSizeState(letterSizeDetail: letterSizeDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch letter size! $e'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<LeisureState> emit) async {
    emit (RefreshScreenState());
  }
}