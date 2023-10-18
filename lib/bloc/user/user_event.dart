part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserEventUpdateProfil extends UserEvent {
  final ModelAuth modelAuth;
  final String nama;
  final String email;
  final String telp;

  UserEventUpdateProfil(
      {required this.modelAuth,
      required this.nama,
      required this.email,
      required this.telp});
}

class UserEventUpdatePhoto extends UserEvent {
  final ModelAuth modelAuth;
  final XFile fileFoto;

  UserEventUpdatePhoto({required this.modelAuth, required this.fileFoto});
}

class UserEventUpdatePassword extends UserEvent {
  final ModelAuth modelAuth;
  final String oldPassword;
  final String newPassword;

  UserEventUpdatePassword(this.oldPassword, this.newPassword, this.modelAuth);
}

class UserEventRegister extends UserEvent {
  final String username;
  final String password;
  final String nama;
  final String email;
  final String nomorhp;
  final String pic;
  final String level;

  UserEventRegister({
    required this.username,
    required this.password,
    required this.nama,
    required this.email,
    required this.nomorhp,
    required this.pic,
    required this.level,
  });
}

class UserEventLupaPassword extends UserEvent {
  final String email;
  UserEventLupaPassword(this.email);
}
