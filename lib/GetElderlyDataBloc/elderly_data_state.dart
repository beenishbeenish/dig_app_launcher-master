part of 'elderly_data_bloc.dart';

@immutable
abstract class ElderlyDataState {}

class InitialState extends ElderlyDataState {}

class LoadingState extends ElderlyDataState {}

class RefreshScreenState extends ElderlyDataState {}

class DataStoredState extends ElderlyDataState {}

class ErrorState extends ElderlyDataState {
  final String error;
  ErrorState({required this.error});
}

class SaveElderlyDataToLocalDBState extends ElderlyDataState {}

class ProductClickAddedToLocalDBState extends ElderlyDataState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends ElderlyDataState {
  final String error;
  InternetErrorState({required this.error});
}