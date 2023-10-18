part of 'otp_bloc.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpStateLoading extends OtpState {}

class OtpStateFailed extends OtpState {
  final String errorMessage;

  OtpStateFailed(this.errorMessage);
}

class OtpStateSuccess extends OtpState {}
