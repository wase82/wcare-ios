import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'laporan_detail_event.dart';

part 'laporan_detail_state.dart';

class LaporanDetailBloc extends Bloc<LaporanDetailEvent, LaporanDetailState> {
  LaporanDetailBloc() : super(LaporanDetailInitial()) {
    on<LaporanDetailEvent>((event, emit) async {
      if (event is LaporanDetailEventGetDetail) {
        try {
          emit(LaporanDetailLoading());
          ModelDetailLaporan modelDetailLaporan =
              await ServiceLaporan.detailLaporan(
                  username: event.username, idLaporan: event.idLaporan);
          if (!modelDetailLaporan.respError) {
            emit(LaporanDetailSuccess(modelDetailLaporan));
          } else {
            emit(LaporanDetailFailed(modelDetailLaporan.respMsg));
          }
        } catch (e) {
          emit(LaporanDetailFailed(e.toString()));
        }
      }
    });
  }
}
