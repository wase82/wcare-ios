import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_level.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:wtoncare/service/service_master.dart';

part 'set_register_event.dart';

part 'set_register_state.dart';

class SetRegisterBloc extends Bloc<SetRegisterEvent, SetRegisterState> {
  SetRegisterBloc() : super(SetRegisterInitial()) {
    on<SetRegisterEvent>((event, emit) async {
      if (event is SetRegisterEventGetDetails) {
        try {
          emit(SetRegisterLoading());
          ModelPic modelPic = await ServiceMaster.reqPic();
          ModelLevel modelJalur = await ServiceMaster.reqLevel();
          emit(SetRegisterSuccess(
              listPic: modelPic.items, listLevel: modelJalur.items));
        } catch (e) {
          emit(SetRegisterFailed(e.toString()));
        }
      }
    });
  }
}
