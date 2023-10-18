part of 'authentication_process_bloc.dart';

@immutable
abstract class AuthenticationProcessEvent {}

class AuthenticationProcessVerify extends AuthenticationProcessEvent {
  final String nip;
  AuthenticationProcessVerify(this.nip);
}

class AuthenticationProcessEventLogin extends AuthenticationProcessEvent {
  final String userName;
  final String token;
  final String tokenfirebase;

  AuthenticationProcessEventLogin({
    required this.userName,
    required this.token,
    required this.tokenfirebase,
  });
}

class AuthenticationProcessEventSP extends AuthenticationProcessEvent {
  AuthenticationProcessEventSP();
}

class AuthenticationProcessEventChangeUser extends AuthenticationProcessEvent {
  final ModelAuth modelAuth;

  AuthenticationProcessEventChangeUser(this.modelAuth);
}

class AuthenticationProcessEventLogout extends AuthenticationProcessEvent {
  final ModelAuth modelAuth;

  AuthenticationProcessEventLogout(this.modelAuth);
}
