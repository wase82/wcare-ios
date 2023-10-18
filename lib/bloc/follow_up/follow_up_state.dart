part of 'follow_up_bloc.dart';

@immutable
abstract class FollowUpState {}

class FollowUpInitial extends FollowUpState {}

class FollowUpLoading extends FollowUpState {}

class FollowUpSuccess extends FollowUpState {}

class FollowUpError extends FollowUpState {
  final String errorMessage;

  FollowUpError(this.errorMessage);
}
