part of 'device_bloc.dart';

enum DeviceOS { android, ios, unknown }

extension GetDeviceDetail on DeviceOS {
  String get text {
    switch (this) {
      case DeviceOS.android:
        return 'Android';
      case DeviceOS.ios:
        return 'IOS';
      default:
        return 'Unknown';
    }
  }
}

class DeviceInitial {
  final String uid;
  final String appVersion;
  final String country;
  final String address;
  final String deviceTipe;
  final double latitude;
  final double longitude;
  final String token;
  final DeviceOS os;

  const DeviceInitial(
      {this.uid = "",
      this.appVersion = "",
      this.country = "",
      this.address = "",
      this.deviceTipe = "",
      this.latitude = 0,
      this.longitude = 0,
      this.token = "",
      this.os = DeviceOS.android});

  DeviceInitial copyWith(
      {String? uid,
      String? appVersion,
      String? country,
      String? address,
      String? deviceTipe,
      double? latitude,
      double? longitude,
      String? token,
      DeviceOS? os}) {
    return DeviceInitial(
        uid: uid ?? this.uid,
        appVersion: appVersion ?? this.appVersion,
        country: country ?? this.country,
        address: address ?? this.address,
        deviceTipe: deviceTipe ?? this.deviceTipe,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        token: token??this.token,
        os: os ?? this.os);
  }

  @override
  String toString() {
    return 'DeviceInitial{uid: $uid, appVersion: $appVersion, country: $country, address: $address, deviceTipe: $deviceTipe, latitude: $latitude, longitude: $longitude, os: $os}';
  }
}
