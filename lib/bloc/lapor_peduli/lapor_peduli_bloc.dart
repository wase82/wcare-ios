import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/model/model_kategori.dart';
import 'package:wtoncare/model/model_keparahan.dart';
import 'package:wtoncare/model/model_kriteria.dart';
import 'package:wtoncare/model/model_lokasi.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:wtoncare/service/service_laporan.dart';

part 'lapor_peduli_event.dart';

part 'lapor_peduli_state.dart';

class LaporPeduliBloc extends Bloc<LaporPeduliEvent, LaporPeduliState> {
  LaporPeduliBloc() : super(LaporPeduliInitial()) {
    on<LaporPeduliEventSimpan>(_mapOnSimpan);
  }

  Future<void> _mapOnSimpan(
      LaporPeduliEventSimpan event, Emitter<LaporPeduliState> emit) async {
    try {
      emit(LaporPeduliLoading("Mengirimkan data ke server"));
      bool asd = await Geolocator.isLocationServiceEnabled();
      if (!asd) {
        emit(LaporPeduliError(errorMessage: 'Harap nyalakan GPS'));
      }
      Position? position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 20));
      ModelGeneral modelGeneral = await ServiceLaporan.simpanLaporan(
        username: event.modelAuth.username,
        step: event.modelAuth.step,
        kdPat: event.modelAuth.kdPat,
        tanggal: event.tanggal,
        lokasi: event.lokasi,
        pic: event.pic,
        kriteria: event.kriteria,
        kategori: event.kategori,
        keparahan: event.keparahan,
        keterangan: event.keterangan,
        kejadian: event.kejadian,
        latitude: position.latitude,
        longitude: position.longitude,
        file: event.fileFoto,
        jumlah: event.jumlah,
      );
      if (modelGeneral.respError) {
        emit(LaporPeduliError(errorMessage: modelGeneral.respMsg));
      } else {
        emit(LaporPeduliSuccess());
      }
    } catch (e) {
      emit(LaporPeduliError(errorMessage: e.toString()));
    }
  }
}
