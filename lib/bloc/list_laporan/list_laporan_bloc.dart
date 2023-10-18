import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_list_laporan.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'list_laporan_event.dart';

part 'list_laporan_state.dart';

class ListLaporanBloc extends Bloc<ListLaporanEvent, ListLaporanState> {
  ListLaporanBloc() : super(ListLaporanStateInitial()) {
    on<ListLaporanEvent>((event, emit) async {
      if (event is ListLaporanEventReqList) {
        try {
          emit(ListLaporanStateLoading());
          ModelListLaporan modelListLaporan =
              await ServiceLaporan.getListLaporan(
            event.modelAuth.username,
            event.modelAuth.level,
            event.modelAuth.kdPat,
            event.modelAuth.step,
            event.modelAuth.picId,
            event.dari,
            event.sampai,
            event.status,
          );
          if (modelListLaporan.items.isEmpty) {
            emit(ListLaporanStateNoData(DateTime.now()));
          } else {
            emit(ListLaporanStateSuccess(
                modelListLaporan.items, DateTime.now()));
          }
        } catch (e) {
          emit(ListLaporanStateFailed(e.toString()));
        }
      }
    });
  }
}
