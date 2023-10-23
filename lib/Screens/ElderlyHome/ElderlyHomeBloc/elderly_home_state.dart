part of 'elderly_home_bloc.dart';

@immutable
abstract class ElderlyHomeState {}

class InitialState extends ElderlyHomeState {}

class LoadingState extends ElderlyHomeState {}

class RefreshScreenState extends ElderlyHomeState {}

class ErrorState extends ElderlyHomeState {

  final String error;
  ErrorState({required this.error});
}

class GetLetterSizeState extends ElderlyHomeState {

  final RequestLetterSizeDetail letterSizeDetail;
  GetLetterSizeState({required this.letterSizeDetail});
}

class GetAllContactsDetailState extends ElderlyHomeState {

  final RequestContactsDetail contactsDetail;
  GetAllContactsDetailState({required this.contactsDetail});       // this.calories
}

class ProductClickAddedToLocalDBState extends ElderlyHomeState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends ElderlyHomeState {

  final String error;
  InternetErrorState({required this.error});
}