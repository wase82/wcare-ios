import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'forward_event.dart';

part 'forward_state.dart';

class ForwardBloc extends Bloc<ForwardEvent, ForwardState> {
  ForwardBloc() : super(ForwardInitial()) {
    on<ForwardEvent>((event, emit) async {
      if (event is ForwardEventForward) {
        try {
          emit(ForwardLoading());
          ModelGeneral modelGeneral = await ServiceLaporan.forwarLaporan(
              username: event.modelAuth.username, laporanId: event.idLaporan);
          if (!modelGeneral.respError) {
            emit(ForwardSuccess());
          } else {
            emit(ForwardError(modelGeneral.respMsg));
          }
        } catch (e) {
          emit(ForwardError(e.toString()));
        }
      }
    });
  }
}
