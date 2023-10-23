part of 'elderly_data_bloc.dart';

abstract class ElderlyDataEvent {}

//Save Elderly Data
class SaveElderlyDataToLocalDB extends ElderlyDataEvent {

  bool bluetoothValue;
  int titleSize, textSize, volumeValue;
  final List<FavoriteContactModel?> favoritePhoneContacts;
  // final List<Photo?> favoriteContactPhotos, emergencyContactPhotos;
  final List<ElderlyEmergencyContacts?> emergencyPhoneContacts;
  final List<ElderlyMedicineModel?> elderlyMedicineModel;
  final List<ElderlyAppModel?> elderlyAppModel;

  SaveElderlyDataToLocalDB({
    required this.titleSize, required this.textSize,
    required this.favoritePhoneContacts,
    required this.emergencyPhoneContacts,
    required this.volumeValue, required this.bluetoothValue,
    required this.elderlyMedicineModel,
    required this.elderlyAppModel
  });
}

class RefreshScreenEvent extends ElderlyDataEvent {
  RefreshScreenEvent();
}