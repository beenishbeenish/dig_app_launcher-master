part of 'leisure_bloc.dart';

abstract class LeisureEvent {}

//Save App
class SaveAppEvent extends LeisureEvent {

  String appName, packageName;
  Uint8List appImage;
  SaveAppEvent({required this.appName, required this.appImage, required this.packageName});
}

//Fetch App
class GetAllAppEvent extends LeisureEvent {
  GetAllAppEvent();
}

//Fetch Letter Size
class GetLetterSizeEvent extends LeisureEvent {
  GetLetterSizeEvent();
}

class RefreshScreenEvent extends LeisureEvent {
  RefreshScreenEvent();
}