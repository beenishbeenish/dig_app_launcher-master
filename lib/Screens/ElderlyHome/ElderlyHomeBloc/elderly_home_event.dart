part of 'elderly_home_bloc.dart';

abstract class ElderlyHomeEvent {}

//Fetch Letter Size
class GetLetterSizeEvent extends ElderlyHomeEvent {
  GetLetterSizeEvent();
}

//Fetch Favorites Contact
class GetAllContactsEvent extends ElderlyHomeEvent {
  GetAllContactsEvent();
}

class RefreshScreenEvent extends ElderlyHomeEvent {
  RefreshScreenEvent();
}