import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_avatar.dart';
import 'package:wtoncare/model/model_general.dart';
import 'package:wtoncare/service/service_user.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UserEventUpdateProfil) {
        try {
          emit(UserLoading());
          ModelGeneral modelGeneral = await ServiceUser.updateProfil(
              event.modelAuth.username, event.nama, event.email, event.telp);
          if (!modelGeneral.respError) {
            ModelAuth modelAuth = event.modelAuth.copyWith(
                nama: event.nama, email: event.email, telp: event.telp);
            emit(UserSuccess(modelAuth));
          } else {
            emit(UserFailed(modelGeneral.respMsg));
          }
        } catch (e) {
          emit(UserFailed(e.toString()));
        }
      } else if (event is UserEventUpdatePhoto) {
        try {
          emit(UserLoading());
          ModelAvatar modelAvatar = await ServiceUser.updatePhoto(
              event.modelAuth.username, event.fileFoto);
          String? avatar = modelAvatar.avatar;
          if (avatar?.isNotEmpty ?? false) {
            ModelAuth modelAuth = event.modelAuth.copyWith(avatar: avatar);
            emit(UserSuccess(modelAuth));
          } else {
            emit(UserFailed(modelAvatar.respMsg));
          }
        } catch (e) {
          emit(UserFailed(e.toString()));
        }
      }
    });
  }
}
