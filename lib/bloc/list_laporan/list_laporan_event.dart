part of 'list_laporan_bloc.dart';

@immutable
abstract class ListLaporanEvent {}

class ListLaporanEventReqList extends ListLaporanEvent {
  final ModelAuth modelAuth;
  final String dari;
  final String sampai;
  final String status;

  ListLaporanEventReqList(this.modelAuth, this.dari, this.sampai, this.status);
}
