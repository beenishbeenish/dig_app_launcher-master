import 'package:bloc/bloc.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/medicine_model.dart';
import 'package:dig_app_launcher/Helper/db_helper.dart';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'medicine_event.dart';
part 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  MedicineBloc() : super(InitialState()) {
    on<SaveMedicineDetailEvent> (_saveMedicineDetailEvent);
    on<GetAllMedicineEvent> (_getMedicineDetailEvent);
    on<GetLetterSizeEvent> (_getLetterSizeEvent);
    // on<UpdateMedicineEvent> (_updateMedicineEvent);
    on<DeleteMedicineEvent> (_deleteMedicineEvent);
    on<RefreshScreenEvent> (_refreshScreenEvent);
  }
  final dbHelper = DatabaseHelper.instance;

  _saveMedicineDetailEvent(SaveMedicineDetailEvent event, Emitter<MedicineState> emit) async {
    emit(LoadingState());
    try {
      final Database db = await DatabaseHelper.instance.database;

      Map<String, dynamic> medicineData = {
        DatabaseHelper.medicineName: event.name,
        DatabaseHelper.medicineImage: event.image,
        DatabaseHelper.medicineHour: event.timeHour,
        DatabaseHelper.medicineMinute: event.timeMinute,
        DatabaseHelper.medicineTime: event.dayTime,
        DatabaseHelper.medicineDays: event.days.join(', '),
      };

      await db.insert(DatabaseHelper.tableMedicine, medicineData);
      emit(DataStoredState());
    } catch (e) {
      emit(ErrorState(error: 'Failed to store medicine data!'));
    }
  }

  _getMedicineDetailEvent(GetAllMedicineEvent event, Emitter<MedicineState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryAllMedicine();
      RequestMedicineDetail medicineDetail = RequestMedicineDetail.fromJson(data);

      emit (GetAllMedicineDetailState(medicineDetail: medicineDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch medicine data!'));
    }
  }

  _getLetterSizeEvent(GetLetterSizeEvent event, Emitter<MedicineState> emit) async {
    emit (LoadingState());
    try {
      var data = await dbHelper.queryLetterSize();
      RequestLetterSizeDetail letterSizeDetail = RequestLetterSizeDetail.fromJson(data);

      emit (GetLetterSizeState(letterSizeDetail: letterSizeDetail));
    } catch (e) {
      emit (ErrorState(error: 'Failed to fetch letter size! $e'));
    }
  }

  // _updateMedicineEvent(UpdateMedicineEvent event, Emitter<MedicineState> emit) async {
  //   emit (LoadingState());
  //   try {
  //     event.medicineDetailModel.medicineName = event.name;
  //     event.medicineDetailModel.medicineTime = event.dropDownValue;
  //     event.medicineDetailModel.medicineImage = event.image;
  //
  //     var data = await dbHelper.updateMedicine(event.medicineDetailModel.toJson());
  //
  //     emit (UpdateMedicineState(medicineDetailModel: event.medicineDetailModel));
  //   } catch (e) {
  //     emit (ErrorState(error: 'Failed to update medicine data!'));
  //   }
  // }

  // _deleteMedicineEvent(DeleteMedicineEvent event, Emitter<MedicineState> emit) async {
  //   emit (LoadingState());
  //   try {
  //     // await dbHelper.deleteMedicine(event.medicineDetail.medicineDetailList![event.index].toJson());
  //     var data = await dbHelper.updateMedicine(event.medicineDetail.medicineDetailList![event.index].toJson());
  //     event.medicineDetail.medicineDetailList!.removeAt(event.index);
  //
  //     emit (GetAllMedicineDetailState(medicineDetail: event.medicineDetail));
  //   } catch (e) {
  //     emit (ErrorState(error: 'Failed to delete medicine!'));
  //   }
  // }

  void _deleteMedicineEvent(DeleteMedicineEvent event, Emitter<MedicineState> emit) async {
    emit(LoadingState());
    try {
      RequestMedicineDetail? medicineDetail = event.medicineDetail;

      if (medicineDetail.medicineDetailList != null) {
        List<MedicineDetailModelLocalDB> medicineList = medicineDetail.medicineDetailList!;

        if (event.index >= 0 && event.index < medicineList.length) {
          medicineList.removeAt(event.index);
          emit(GetAllMedicineDetailState(medicineDetail: medicineDetail));

          // Perform the deletion in the database
          await dbHelper.deleteMedicine(event.index);

          // Display a success message or perform any additional actions
        } else {
          emit(ErrorState(error: 'Invalid index!'));
        }
      } else {
        emit(ErrorState(error: 'Invalid medicine detail!'));
      }
    } catch (e) {
      emit(ErrorState(error: 'Failed to delete medicine!'));
    }
  }

  _refreshScreenEvent(RefreshScreenEvent event, Emitter<MedicineState> emit) async {
    emit (RefreshScreenState());
  }
}