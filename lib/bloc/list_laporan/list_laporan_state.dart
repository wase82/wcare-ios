part of 'list_laporan_bloc.dart';

@immutable
abstract class ListLaporanState {}

class ListLaporanStateInitial extends ListLaporanState {}

class ListLaporanStateLoading extends ListLaporanState {}

class ListLaporanStateSuccess extends ListLaporanState {
  final List<ListLaporan> list;
  final DateTime dateTimeNow;

  ListLaporanStateSuccess(this.list, this.dateTimeNow);
}

class ListLaporanStateNoData extends ListLaporanState {
  final DateTime dateTimeNow;
  ListLaporanStateNoData(this.dateTimeNow);
}

class ListLaporanStateFailed extends ListLaporanState {
  final String errorMessage;

  ListLaporanStateFailed(this.errorMessage);
}
