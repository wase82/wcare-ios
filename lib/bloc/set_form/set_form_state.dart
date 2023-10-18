part of 'set_form_bloc.dart';

@immutable
abstract class SetFormState {}

class SetFormInitial extends SetFormState {}

class SetFormLoading extends SetFormState {}

class SetFormSuccess extends SetFormState {
  final List<ListLokasi> listLokasi;
  final List<ListPic> listPic;
  final List<ListKriteria> listKriteria;
  final List<ListKategori> listKategori;
  final List<ListKeparahan> listKeparahan;

  SetFormSuccess({
    required this.listLokasi,
    required this.listPic,
    required this.listKriteria,
    required this.listKategori,
    required this.listKeparahan,
  });
}

class SetFormFailed extends SetFormState {
  final String errorMessage;

  SetFormFailed(this.errorMessage);
}

class SetLocationFailed extends SetFormState {
  final String errorMessage;

  SetLocationFailed(this.errorMessage);
}
