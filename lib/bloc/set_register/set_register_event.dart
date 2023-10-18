part of 'set_register_bloc.dart';

@immutable
abstract class SetRegisterEvent {}

class SetRegisterEventGetDetails extends SetRegisterEvent {
  SetRegisterEventGetDetails();
}
