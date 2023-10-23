part of 'sound_bloc.dart';

@immutable
abstract class SoundState {}

class InitialState extends SoundState {}

class LoadingState extends SoundState {}

class RefreshScreenState extends SoundState {}

class DataStoredState extends SoundState {}

class ErrorState extends SoundState {
  final String error;
  ErrorState({required this.error});
}

class SaveVolumeState extends SoundState {}

class SaveBluetoothValueState extends SoundState {}

class GetSoundState extends SoundState {

  final RequestSoundDetail soundDetail;
  GetSoundState({required this.soundDetail});
}

class ProductClickAddedToLocalDBState extends SoundState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends SoundState {
  final String error;
  InternetErrorState({required this.error});
}