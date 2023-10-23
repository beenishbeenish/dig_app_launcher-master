import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'elderly_home_event.dart';
part 'elderly_home_state.dart';

class ElderlyHomeBloc extends Bloc<ElderlyHomeEvent, ElderlyHomeState> {
  ElderlyHomeBloc() : super(InitialState()) {
    on<GetLetterSizeEvent> (_getLetterSizeEvent);
    on<GetAllContactsEvent> (_getContactsDetailEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _getLetterSizeEvent(GetLetterSizeEvent event, Emitter<ElderlyHomeState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryLetterSize();
      RequestLetterSizeDetail letterSizeDetail = RequestLetterSizeDetail.fromJson(data);

      emit (GetLetterSizeState(letterSizeDetail: letterSizeDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch letter size! $e'));
    }
  }

  _getContactsDetailEvent(GetAllContactsEvent event, Emitter<ElderlyHomeState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryAllContacts();
      RequestContactsDetail contactsDetail = RequestContactsDetail.fromJson(data);

      print('Contact Detail Screen: $data');
      emit (GetAllContactsDetailState(contactsDetail: contactsDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch contacts data! $e'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<ElderlyHomeState> emit) async {
    emit (RefreshScreenState());
  }
}