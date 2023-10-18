part of 'laporan_detail_bloc.dart';

@immutable
abstract class LaporanDetailEvent {}

class LaporanDetailEventGetDetail extends LaporanDetailEvent {
  final String username;
  final String idLaporan;

  LaporanDetailEventGetDetail(
      {required this.username, required this.idLaporan});
}
