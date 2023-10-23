part of 'medicine_bloc.dart';

abstract class MedicineEvent {}

//Save Medicine
class SaveMedicineDetailEvent extends MedicineEvent {

  String name, timeHour, timeMinute, dayTime, image;
  List<String> days;
  SaveMedicineDetailEvent({required this.name, required this.timeHour, required this.dayTime, required this.timeMinute, required this.days, required this.image});
}

//Fetch Medicine
class GetAllMedicineEvent extends MedicineEvent {
  GetAllMedicineEvent();
}

//Fetch Letter Size
class GetLetterSizeEvent extends MedicineEvent {
  GetLetterSizeEvent();
}

//Update Medicine
// class UpdateMedicineEvent extends MedicineEvent {
//
//   MedicineDetailModelLocalDB medicineDetailModel;
//   String name, image, time, days;
//   UpdateMedicineEvent({required this.medicineDetailModel, required this.name, required this.dropDownValue, required this.image});
// }

//Delete Medicine
class DeleteMedicineEvent extends MedicineEvent {

  RequestMedicineDetail medicineDetail;
  int index;
  DeleteMedicineEvent({required this.medicineDetail, required this.index});
}

class RefreshScreenEvent extends MedicineEvent {
  RefreshScreenEvent();
}
