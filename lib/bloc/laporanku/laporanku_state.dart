part of 'laporanku_bloc.dart';

@immutable
abstract class LaporankuState {}

class LaporankuStateInitial extends LaporankuState {}


class LaporankuStateLoading extends LaporankuState {}

class LaporankuStateSuccess extends LaporankuState {
  final List<ListLaporan> listku;
  final DateTime dateTimeNow;

  LaporankuStateSuccess(this.listku, this.dateTimeNow);
}

class LaporankuStateNoData extends LaporankuState {
  final DateTime dateTimeNow;

  LaporankuStateNoData(this.dateTimeNow);
}

class LaporankuStateFailed extends LaporankuState {
  final String errorMessage;

  LaporankuStateFailed(this.errorMessage);
}
