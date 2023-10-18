part of 'set_register_bloc.dart';

@immutable
abstract class SetRegisterState {}

class SetRegisterInitial extends SetRegisterState {}

class SetRegisterLoading extends SetRegisterState {}

class SetRegisterSuccess extends SetRegisterState {
  final List<ListPic> listPic;
  final List<ListLevel> listLevel;

  SetRegisterSuccess({required this.listPic, required this.listLevel});
}

class SetRegisterFailed extends SetRegisterState {
  final String errorMessage;

  SetRegisterFailed(this.errorMessage);
}
