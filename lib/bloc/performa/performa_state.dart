part of 'performa_bloc.dart';

@immutable
abstract class PerformaState {}

class PerformaInitial extends PerformaState {}

class PerformaStateLoading extends PerformaState {}

class PerformaStateSuccess extends PerformaState {
  final List<Detail> detail;
  final List<DetailKriteria> detailKriteria;
  final List<DetailKeparahan> detailKeparahan;
  final double prosentase;
  final int totalTemuan;
  final int totalTemuanSelesai;
  final DateTime dateTimeNow;
  final String persen;

  PerformaStateSuccess(
      this.detail,
      this.detailKriteria,
      this.detailKeparahan,
      this.dateTimeNow,
      this.prosentase,
      this.totalTemuan,
      this.totalTemuanSelesai,
      this.persen);
}

class PerformaStateNoData extends PerformaState {
  final DateTime dateTimeNow;

  PerformaStateNoData(this.dateTimeNow);
}

class PerformaStateFailed extends PerformaState {
  final String errorMessage;

  PerformaStateFailed(this.errorMessage);
}
