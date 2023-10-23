part of 'letter_size_bloc.dart';

abstract class LetterSizeEvent {}

//Save Letter Size
class SaveLetterSizeEvent extends LetterSizeEvent {

  int titleSize, textSize;
  SaveLetterSizeEvent(this.titleSize, this.textSize);
}

//Fetch Letter Size
class GetLetterSizeEvent extends LetterSizeEvent {
  GetLetterSizeEvent();
}

class RefreshScreenEvent extends LetterSizeEvent {
  RefreshScreenEvent();
}