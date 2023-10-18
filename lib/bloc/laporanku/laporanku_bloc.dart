import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_list_laporan.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'laporanku_event.dart';

part 'laporanku_state.dart';

class LaporankuBloc extends Bloc<LaporankuEvent, LaporankuState> {
  LaporankuBloc() : super(LaporankuStateInitial()) {
    on<LaporankuEvent>((event, emit) async {
      if (event is LaporankuEventReqLaporan) {
        try {
          emit(LaporankuStateLoading());
          ModelListLaporan modelListLaporan =
              await ServiceLaporan.getLaporanku(event.modelAuth.username);
          if (modelListLaporan.items.isEmpty) {
            emit(LaporankuStateNoData(DateTime.now()));
          } else {
            emit(LaporankuStateSuccess(modelListLaporan.items, DateTime.now()));
          }
        } catch (e) {
          emit(LaporankuStateFailed(e.toString()));
        }
      }
    });
  }
}
