part of 'laporan_detail_bloc.dart';

@immutable
abstract class LaporanDetailState {}

class LaporanDetailInitial extends LaporanDetailState {}

class LaporanDetailLoading extends LaporanDetailState {}

class LaporanDetailSuccess extends LaporanDetailState {
  final ModelDetailLaporan modelDetailLaporan;

  LaporanDetailSuccess(this.modelDetailLaporan);
}

class LaporanDetailFailed extends LaporanDetailState {
  final String errorMessage;

  LaporanDetailFailed(this.errorMessage);
}
