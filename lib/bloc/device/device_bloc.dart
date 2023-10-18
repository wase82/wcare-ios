

import 'package:device_info_plus/device_info_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceInitial> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  DeviceBloc() : super(const DeviceInitial()) {
    on<DeviceEvent>((event, emit) async {
      if (event is DeviceEventGetLocation) {
        emit(state.copyWith(
            latitude: event.latitude, longitude: event.longitude));
      } else if (event is DeviceEventAddToken) {
        emit(state.copyWith(token: event.token ?? ''));
      }
    });
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
