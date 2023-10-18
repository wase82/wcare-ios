import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'follow_up_event.dart';

part 'follow_up_state.dart';

class FollowUpBloc extends Bloc<FollowUpEvent, FollowUpState> {
  FollowUpBloc() : super(FollowUpInitial()) {
    on<FollowUpEvent>((event, emit) async {
      if (event is FollowUpEventKirimLaporan) {
        try {
          emit(FollowUpLoading());
          ModelGeneral modelGeneral = await ServiceLaporan.simpanFollowUp(
              username: event.modelAuth.username,
              laporanId: event.laporanId,
              keterangan: event.keterangan,
              file: event.fileFoto,
              modelAuth: event.modelAuth);
          if (!modelGeneral.respError) {
            emit(FollowUpSuccess());
          } else {
            emit(FollowUpError(modelGeneral.respMsg));
          }
        } catch (e) {
          emit(FollowUpError(e.toString()));
        }
      }
    });
  }
}
