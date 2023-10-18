part of 'lapor_peduli_bloc.dart';

@immutable
abstract class LaporPeduliEvent {}

class LaporPeduliEventSimpan extends LaporPeduliEvent {
  final ListLokasi lokasi;
  final ListPic pic;
  final ListKriteria kriteria;
  final ListKategori kategori;
  final ListKeparahan keparahan;
  final DeviceInitial deviceInitial;
  final ModelAuth modelAuth;
  final XFile fileFoto;
  final String tanggal;
  final String keterangan;
  final String kejadian;
  final int jumlah;

  LaporPeduliEventSimpan({
    required this.modelAuth,
    required this.tanggal,
    required this.lokasi,
    required this.pic,
    required this.kriteria,
    required this.kategori,
    required this.keparahan,
    required this.keterangan,
    required this.kejadian,
    required this.deviceInitial,
    required this.fileFoto,
    required this.jumlah,
  });
}
