part of 'forward_bloc.dart';

@immutable
abstract class ForwardEvent {}

class ForwardEventForward extends ForwardEvent{
  final ModelAuth modelAuth;
  final String idLaporan;
  ForwardEventForward(this.modelAuth, this.idLaporan);
}