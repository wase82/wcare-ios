part of 'forward_bloc.dart';

@immutable
abstract class ForwardState {}

class ForwardInitial extends ForwardState {}

class ForwardLoading extends ForwardState {}

class ForwardSuccess extends ForwardState {}

class ForwardError extends ForwardState {
  final String errorMessage;

  ForwardError(this.errorMessage);
}
