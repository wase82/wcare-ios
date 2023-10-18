part of 'update_proses_bloc.dart';

@immutable
abstract class UpdateProsesState {}

class UpdateProsesInitial extends UpdateProsesState {}

class UpdateProsesLoading extends UpdateProsesState {}

class UpdateProsesSuccess extends UpdateProsesState {}

class UpdateProsesError extends UpdateProsesState {
  final String errorMessage;

  UpdateProsesError(this.errorMessage);
}