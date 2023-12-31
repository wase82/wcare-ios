import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpEvent>((event, emit) async {
      try {
        // emit(OtpLoading());
        // ModelPic modelPic = await ProviderMaster.reqPic();
        // emit(OtpBlocSuccess(
        //     listPic: modelPic.items, listLevel: modelJalur.items));
      } catch (e) {
        emit(OtpStateFailed(e.toString()));
      }
    });
  }
}
