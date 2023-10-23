part of 'medicine_bloc.dart';

@immutable
abstract class MedicineState {}

class InitialState extends MedicineState {}

class LoadingState extends MedicineState {}

class RefreshScreenState extends MedicineState {}

class DataStoredState extends MedicineState {}

class ErrorState extends MedicineState {
  final String error;
  ErrorState({required this.error});
}

class SaveMedicineState extends MedicineState {}

class GetAllMedicineDetailState extends MedicineState {
  final RequestMedicineDetail medicineDetail;
  GetAllMedicineDetailState({required this.medicineDetail});
}

class GetLetterSizeState extends MedicineState {

  final RequestLetterSizeDetail letterSizeDetail;
  GetLetterSizeState({required this.letterSizeDetail});
}

class UpdateMedicineState extends MedicineState {
  MedicineDetailModelLocalDB medicineDetailModel;
  UpdateMedicineState({required this.medicineDetailModel});       // this.calories
}

class ProductClickAddedToLocalDBState extends MedicineState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends MedicineState {
  final String error;
  InternetErrorState({required this.error});
}