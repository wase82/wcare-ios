import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'update_proses_event.dart';

part 'update_proses_state.dart';

class UpdateProsesBloc extends Bloc<UpdateProsesEvent, UpdateProsesState> {
  UpdateProsesBloc() : super(UpdateProsesInitial()) {
    on<UpdateProsesEvent>(
      (event, emit) async {
        if (event is UpdateProsesEventUpdateStatus) {
          try {
            emit(UpdateProsesLoading());
            ModelGeneral modelGeneral = await ServiceLaporan.updateProses(
                username: event.modelAuth.username, laporanId: event.idLaporan);
            if (!modelGeneral.respError) {
              emit(UpdateProsesSuccess());
            } else {
              emit(UpdateProsesError(modelGeneral.respMsg));
            }
          } catch (e) {
            emit(UpdateProsesError(e.toString()));
          }
        }
      },
    );
  }
}
