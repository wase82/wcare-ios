part of 'device_bloc.dart';

@immutable
abstract class DeviceEvent {}

class DeviceEventAddToken extends DeviceEvent {
  final String? token;
  DeviceEventAddToken(this.token);
}

class DeviceEventGetLocation extends DeviceEvent {
  final double latitude;
  final double longitude;
  DeviceEventGetLocation({required this.latitude, required this.longitude});
}


