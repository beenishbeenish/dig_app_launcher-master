import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/sound_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sound_event.dart';
part 'sound_state.dart';

class SoundBloc extends Bloc<SoundEvent, SoundState> {
  SoundBloc() : super(InitialState()) {
    on<SaveVolumeEvent> (_saveVolumeEvent);
    on<SaveBluetoothValueEvent> (_saveBluetoothValueEvent);
    on<GetSoundEvent> (_getSoundEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveVolumeEvent(SaveVolumeEvent event, Emitter<SoundState> emit) async {
    emit(LoadingState());
    try {
      List<Map<String, dynamic>> soundData = [];
      if (event.volume >= 0) {
        // Create a map of contact data to be inserted into the database
        Map<String, dynamic> volumeValue = {
          DatabaseHelper.volume: event.volume,
        };
        soundData.add(volumeValue);
      }

      await dbHelper.deleteVolume();
      for (Map<String, dynamic> volumeValue in soundData) {
        await dbHelper.insertSound(volumeValue);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store device volume!'));
    }
  }

  _saveBluetoothValueEvent(SaveBluetoothValueEvent event, Emitter<SoundState> emit) async {
    emit(LoadingState());
    try {
      List<Map<String, dynamic>> soundData = [];

      Map<String, dynamic> bluetoothValue = {
        DatabaseHelper.isBluetooth: event.bluetoothValue,
      };
      soundData.add(bluetoothValue);

      await dbHelper.deleteBluetooth();
      for (Map<String, dynamic> bluetoothValue in soundData) {
        await dbHelper.insertSound(bluetoothValue);
      }

      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store device bluetooth value!'));
    }
  }

  _getSoundEvent(GetSoundEvent event, Emitter<SoundState> emit) async {
    emit (LoadingState());
    var data = await dbHelper.querySound();
    print('Data: $data');
    RequestSoundDetail soundDetail = RequestSoundDetail.fromJson(data);

    emit (GetSoundState(soundDetail: soundDetail));
    try {

    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch sound! $e'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<SoundState> emit) async {
    emit (RefreshScreenState());
  }
}