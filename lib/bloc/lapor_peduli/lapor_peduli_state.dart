part of 'lapor_peduli_bloc.dart';

@immutable
abstract class LaporPeduliState {}

class LaporPeduliInitial extends LaporPeduliState {}

class LaporPeduliLoading extends LaporPeduliState {
  final String loadingMessage;

  LaporPeduliLoading(this.loadingMessage);
}
class LaporPeduliSuccess extends LaporPeduliState {}

class LaporPeduliError extends LaporPeduliState {
  final String errorMessage;

  LaporPeduliError(
      {required this.errorMessage});
}
