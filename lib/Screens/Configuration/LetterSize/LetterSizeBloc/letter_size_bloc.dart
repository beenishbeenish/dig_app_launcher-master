import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'letter_size_event.dart';
part 'letter_size_state.dart';

class LetterSizeBloc extends Bloc<LetterSizeEvent, LetterSizeState> {
  LetterSizeBloc() : super(InitialState()) {
    on<SaveLetterSizeEvent> (_saveLetterSizeEvent);
    on<GetLetterSizeEvent> (_getLetterSizeEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveLetterSizeEvent(SaveLetterSizeEvent event, Emitter<LetterSizeState> emit) async {
    emit(LoadingState());
    try {
      List<Map<String, dynamic>> letterSizeData = [];
      if (event.titleSize != 0 && event.textSize != 0) {
        // Create a map of contact data to be inserted into the database
        Map<String, dynamic> letterSize = {
          DatabaseHelper.titleSize: event.titleSize,
          DatabaseHelper.textSize: event.textSize,
        };
        letterSizeData.add(letterSize);
      }

      await dbHelper.clearLetterSize();
      // Insert the contacts into the database
      for (Map<String, dynamic> letterSize in letterSizeData) {
        await dbHelper.insertLetterSize(letterSize);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store letter size!'));
    }
  }


  _getLetterSizeEvent(GetLetterSizeEvent event, Emitter<LetterSizeState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryLetterSize();
      RequestLetterSizeDetail letterSizeDetail = RequestLetterSizeDetail.fromJson(data);

      emit (GetLetterSizeState(letterSizeDetail: letterSizeDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch letter size! $e'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<LetterSizeState> emit) async {
    emit (RefreshScreenState());
  }
}