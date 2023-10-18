part of 'follow_up_bloc.dart';

@immutable
abstract class FollowUpEvent {}

class FollowUpEventKirimLaporan extends FollowUpEvent {
  final ModelAuth modelAuth;
  final XFile fileFoto;
  final String keterangan;
  final String laporanId;
  final DeviceInitial deviceInitial;

  FollowUpEventKirimLaporan({
    required this.modelAuth,
    required this.fileFoto,
    required this.keterangan,
    required this.laporanId,
    required this.deviceInitial,
  });
}
