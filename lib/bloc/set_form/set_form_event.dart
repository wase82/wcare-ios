part of 'set_form_bloc.dart';

@immutable
abstract class SetFormEvent {}

class SetFormEventGetDetails extends SetFormEvent {
  final String username;

  SetFormEventGetDetails(this.username);
}
