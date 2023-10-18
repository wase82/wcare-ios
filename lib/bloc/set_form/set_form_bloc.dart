import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wtoncare/model/model_kategori.dart';
import 'package:wtoncare/model/model_keparahan.dart';
import 'package:wtoncare/model/model_kriteria.dart';
import 'package:wtoncare/model/model_lokasi.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:wtoncare/service/service_master.dart';

part 'set_form_event.dart';

part 'set_form_state.dart';

class SetFormBloc extends Bloc<SetFormEvent, SetFormState> {
  SetFormBloc() : super(SetFormInitial()) {
    on<SetFormEvent>((event, emit) async {
      if (event is SetFormEventGetDetails) {
        try {
          emit(SetFormLoading());
          bool isLocationAllowed = await cekLokasi();
          if (!isLocationAllowed) {
            emit(SetLocationFailed(
                "Aplikasi membutuhkan akses lokasi. \n Harap nyalakan GPS"));
            return;
          }
          ModelLokasi modelLokasi = await ServiceMaster.reqLokasi();
          ModelPic modelPic = await ServiceMaster.reqPic();
          ModelKriteria modelKriteria = await ServiceMaster.reqKriteria();
          ModelKategori modelKategori = await ServiceMaster.reqKategori();
          ModelKeparahan modelKeparahan = await ServiceMaster.reqKeparahan();
          emit(
            SetFormSuccess(
              listLokasi: modelLokasi.items,
              listPic: modelPic.items,
              listKriteria: modelKriteria.items,
              listKategori: modelKategori.items,
              listKeparahan: modelKeparahan.items,
            ),
          );
        } catch (e) {
          emit(SetFormFailed(e.toString()));
        }
      }
    });
  }

  Future<bool> cekLokasi() async {
    bool isLocationServiceGranted = true;
    bool isCameraServiceGranted = true;
    bool isLocationOn = true;
    PermissionStatus cameraServiceStatus = await Permission.camera.status;
    PermissionStatus locationServiceStatus = await Permission.location.status;
    if (cameraServiceStatus != PermissionStatus.granted) {
      isCameraServiceGranted = false;
      cameraServiceStatus = await Permission.camera.request();
      if (cameraServiceStatus == PermissionStatus.granted) {
        isCameraServiceGranted = true;
      }
    }
    if (locationServiceStatus != PermissionStatus.granted) {
      isLocationServiceGranted = false;
      locationServiceStatus = await Permission.location.request();
      if (locationServiceStatus == PermissionStatus.granted) {
        isLocationServiceGranted = true;
      }
    }
    isLocationOn = await Geolocator.isLocationServiceEnabled();
    if (isLocationOn && isCameraServiceGranted && isLocationServiceGranted) {
      return true;
    } else {
      return false;
    }
  }
}
