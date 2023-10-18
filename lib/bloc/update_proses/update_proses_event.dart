part of 'update_proses_bloc.dart';

@immutable
abstract class UpdateProsesEvent {}

class UpdateProsesEventUpdateStatus extends UpdateProsesEvent {
  final ModelAuth modelAuth;
  final String idLaporan;

  UpdateProsesEventUpdateStatus(this.modelAuth, this.idLaporan);
}