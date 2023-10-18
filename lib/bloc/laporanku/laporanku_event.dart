part of 'laporanku_bloc.dart';

@immutable
abstract class LaporankuEvent {}

class LaporankuEventReqLaporan extends LaporankuEvent{
  final ModelAuth modelAuth;
  LaporankuEventReqLaporan(this.modelAuth);
}