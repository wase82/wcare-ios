part of 'authentication_process_bloc.dart';

@immutable
abstract class AuthenticationProcessState {}

class AuthenticationProcessVerifySuccess extends AuthenticationProcessState {
  final String nama;
  final String waNumber;
  AuthenticationProcessVerifySuccess(this.nama, this.waNumber);
}

class AuthenticationProcessInitial extends AuthenticationProcessState {}

class AuthenticationProcessLoading extends AuthenticationProcessState {}

class AuthenticationProcessSuccess extends AuthenticationProcessState {
  final ModelAuth modelAuth;

  AuthenticationProcessSuccess(this.modelAuth);
}

class AuthenticationProcessError extends AuthenticationProcessState {
  final String errorMessage;

  AuthenticationProcessError({required this.errorMessage});
}
