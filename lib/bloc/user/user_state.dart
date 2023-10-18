part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final ModelAuth modelAuth;
  UserSuccess(this.modelAuth);
}

class UserFailed extends UserState {
  final String errorMessage;
  UserFailed(this.errorMessage);
}
