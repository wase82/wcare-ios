part of 'performa_bloc.dart';

@immutable
abstract class PerformaEvent {}
class PerformaEventReqPerforma extends PerformaEvent{
  final ModelAuth modelAuth;
  PerformaEventReqPerforma(this.modelAuth);
}
