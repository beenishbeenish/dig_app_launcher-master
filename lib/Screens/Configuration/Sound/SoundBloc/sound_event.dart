part of 'sound_bloc.dart';

abstract class SoundEvent {}

//Save Volume
class SaveVolumeEvent extends SoundEvent {

  int volume;
  SaveVolumeEvent(this.volume);
}

//Save BLuetooth Value
class SaveBluetoothValueEvent extends SoundEvent {

  bool bluetoothValue;
  SaveBluetoothValueEvent(this.bluetoothValue);
}

//Fetch Sound
class GetSoundEvent extends SoundEvent {
  GetSoundEvent();
}

class RefreshScreenEvent extends SoundEvent {
  RefreshScreenEvent();
}