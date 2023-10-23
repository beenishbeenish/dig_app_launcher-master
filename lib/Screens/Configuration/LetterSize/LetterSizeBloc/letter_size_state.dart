part of 'letter_size_bloc.dart';

@immutable
abstract class LetterSizeState {}

class InitialState extends LetterSizeState {}

class LoadingState extends LetterSizeState {}

class RefreshScreenState extends LetterSizeState {}

class DataStoredState extends LetterSizeState {}

class ErrorState extends LetterSizeState {
  final String error;
  ErrorState({required this.error});
}

class SaveLetterSizeState extends LetterSizeState {}

class GetLetterSizeState extends LetterSizeState {

  final RequestLetterSizeDetail letterSizeDetail;
  GetLetterSizeState({required this.letterSizeDetail});
}

class ProductClickAddedToLocalDBState extends LetterSizeState {
  ProductClickAddedToLocalDBState();
}

class InternetErrorState extends LetterSizeState {
  final String error;
  InternetErrorState({required this.error});
}