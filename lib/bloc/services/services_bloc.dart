import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meta/meta.dart';

part 'services_event.dart';

part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesInitial()) {
    on<ServicesEventCheckPermission>(_mapOnReqPerm);
    on<ServicesEventReqLocation>(_mapOnReqLoc);
  }
  Future<void> _mapOnReqPerm(
      ServicesEventCheckPermission event, Emitter<ServicesState> emit) async {
    emit(ServicesLoading());
    bool isLocationServiceGranted = true;
    bool isCameraServiceGranted = true;
    bool isLocationOn = true;
    bool isNotificationGranted = true;
    PermissionStatus cameraServiceStatus = await Permission.camera.status;
    PermissionStatus locationServiceStatus = await Permission.location.status;
    PermissionStatus notificationServiceStatus =
        await Permission.notification.status;
    if (cameraServiceStatus != PermissionStatus.granted) {
      isCameraServiceGranted = false;
      cameraServiceStatus = await Permission.camera.request();
      if (cameraServiceStatus == PermissionStatus.granted) {
        isCameraServiceGranted = true;
      }
    }

    if (locationServiceStatus != PermissionStatus.granted) {
      isLocationServiceGranted = false;
      locationServiceStatus = await Permission.location.request();
      if (locationServiceStatus == PermissionStatus.granted) {
        isLocationServiceGranted = true;
      }
    }

    if (notificationServiceStatus != PermissionStatus.granted) {
      isNotificationGranted = false;
      notificationServiceStatus = await Permission.notification.request();
      if (notificationServiceStatus == PermissionStatus.granted) {
        isNotificationGranted = true;
      }
    }
    isLocationOn = true;
    if (isLocationServiceGranted && isCameraServiceGranted && isLocationOn) {
      emit(ServicesOK());
    } else {
      emit(ServicesConflicted(
        cameraServices: isCameraServiceGranted,
        locationServices: isLocationServiceGranted,
        locationIsOn: isLocationOn,
        notification: isNotificationGranted,
      ));
    }
  }

  Future<void> _mapOnReqLoc(
      ServicesEventReqLocation event, Emitter<ServicesState> emit) async {
    try {
      bool asd = await Geolocator.isLocationServiceEnabled();
      if (asd) {
        Position? position = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 20));
        emit(ServicesGotLocation(
            lat: position.latitude, long: position.longitude));
      } else {
        emit(ServicesError('Please turn on GPS'));
      }
    } on TimeoutException {
      emit(ServicesError("Couldn't get location. Please try again later"));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
