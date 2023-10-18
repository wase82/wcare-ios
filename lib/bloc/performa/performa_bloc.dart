import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_jumlah.dart';
import 'package:wtoncare/model/model_perfom.dart';
import 'package:wtoncare/model/model_perform_keparahan.dart';
import 'package:wtoncare/model/model_perform_kriteria.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'performa_event.dart';

part 'performa_state.dart';

class PerformaBloc extends Bloc<PerformaEvent, PerformaState> {
  PerformaBloc() : super(PerformaInitial()) {
    on<PerformaEvent>((event, emit) async {
      if (event is PerformaEventReqPerforma) {
        try {
          emit(PerformaStateLoading());
          ModelPerform modelPerform = await ServiceLaporan.detailPerforma(
              username: event.modelAuth.username,
              kdPat: event.modelAuth.kdPat,
              picId: event.modelAuth.picId);
          ModelPerformKriteria modelPerformKriteria =
              await ServiceLaporan.performaKriteria(
                  username: event.modelAuth.username,
                  kdPat: event.modelAuth.kdPat,
                  picId: event.modelAuth.picId);
          ModelPerformKeparahan modelPerformKeparahan =
              await ServiceLaporan.performaKeparahan(
                  username: event.modelAuth.username,
                  kdPat: event.modelAuth.kdPat,
                  picId: event.modelAuth.picId);
          if (modelPerform.detail.isEmpty) {
            emit(PerformaStateNoData(DateTime.now()));
          } else {
            ModelJumlah modelJumlah = await ServiceLaporan.detailProsentase(
                username: event.modelAuth.username,
                kdPat: event.modelAuth.kdPat,
                picId: event.modelAuth.picId);
            int temuanSelesai = modelJumlah.jumlahlaporanselesai;
            int temuan = modelJumlah.jumlahlaporan;
            double asd = 0.0;
            emit(PerformaStateSuccess(
                modelPerform.detail,
                modelPerformKriteria.detail,
                modelPerformKeparahan.detail,
                DateTime.now(),
                asd,
                temuan,
                temuanSelesai,
                modelJumlah.persen));
          }
        } catch (e) {
          emit(PerformaStateFailed(e.toString()));
        }
      }
    });
  }
}
