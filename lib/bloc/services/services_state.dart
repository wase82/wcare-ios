part of 'services_bloc.dart';

@immutable
abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {
  ServicesLoading();
}

class ServicesOK extends ServicesState {}

class ServicesGotLocation extends ServicesState {
  final double lat;
  final double long;

  ServicesGotLocation({required this.lat, required this.long});
}

class ServicesConflicted extends ServicesState {
  final bool cameraServices;
  final bool locationServices;
  final bool locationIsOn;
  final bool notification;

  ServicesConflicted({
    required this.cameraServices,
    required this.locationServices,
    required this.locationIsOn,
    required this.notification,
  });
}

class ServicesError extends ServicesState {
  final String message;

  ServicesError(this.message);
}
