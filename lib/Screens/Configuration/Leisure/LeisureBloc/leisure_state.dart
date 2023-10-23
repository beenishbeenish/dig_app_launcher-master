part of 'leisure_bloc.dart';

@immutable
abstract class LeisureState {}

class InitialState extends LeisureState {}

class LoadingState extends LeisureState {}

class RefreshScreenState extends LeisureState {}

class DataStoredState extends LeisureState {}

class ErrorState extends LeisureState {
  final String error;
  ErrorState({required this.error});
}

class SaveAppState extends LeisureState {}

class GetAllAppState extends LeisureState {

  final RequestAppData appDetail;
  GetAllAppState({required this.appDetail});
}

class GetLetterSizeState extends LeisureState {

  final RequestLetterSizeDetail letterSizeDetail;
  GetLetterSizeState({required this.letterSizeDetail});
}

class ProductClickAddedToLocalDBState extends LeisureState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends LeisureState {
  final String error;
  InternetErrorState({required this.error});
}