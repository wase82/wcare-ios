import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:wtoncare/model/model_login.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_verify.dart';
import 'package:wtoncare/service/service_login.dart';
import 'package:wtoncare/shared/util/shared_preference.dart';

part 'authentication_process_event.dart';

part 'authentication_process_state.dart';

class AuthenticationProcessBloc
    extends Bloc<AuthenticationProcessEvent, AuthenticationProcessState> {
  AuthenticationProcessBloc() : super(AuthenticationProcessInitial()) {
    on<AuthenticationProcessEvent>((event, emit) async {
      if (event is AuthenticationProcessVerify) {
        try {
          emit(AuthenticationProcessLoading());
          ModelVerifyUser modelVerifyUser =
              await ServiceAuthenticated.verifyUser(event.nip);
          if (!modelVerifyUser.respError) {
            emit(AuthenticationProcessVerifySuccess(
                modelVerifyUser.nama, modelVerifyUser.waNumber));
          } else {
            emit(AuthenticationProcessError(
                errorMessage: modelVerifyUser.respMsg));
          }
        } catch (e) {
          emit(AuthenticationProcessError(errorMessage: e.toString()));
        }
      } else if (event is AuthenticationProcessEventLogin) {
        try {
          emit(AuthenticationProcessLoading());
          ModelLogin modelLogin = await ServiceAuthenticated.reqToken(
              username: event.userName,
              token: event.token,
              tokenfirebase: event.tokenfirebase);
          if (!modelLogin.respError) {
            ModelAuth modelAuth = ModelAuth(
                username: modelLogin.username ?? '',
                nama: modelLogin.nama ?? '',
                telp: modelLogin.telp ?? '',
                email: modelLogin.email ?? '',
                picId: modelLogin.picId ?? '',
                bagian: modelLogin.bagian ?? '',
                step: modelLogin.step ?? '',
                avatar: modelLogin.avatar ?? '',
                level: modelLogin.level ?? '',
                device: modelLogin.device ?? '',
                kdPat: modelLogin.kdPat ?? '',
                unitNama: modelLogin.unitNama ?? '',
                dateTimeLogin: DateTime.now());
            emit(AuthenticationProcessSuccess(modelAuth));
            modelLogin.picId != null
                ? FirebaseMessaging.instance.subscribeToTopic(modelLogin.picId!)
                : {};
            modelLogin.step != null
                ? FirebaseMessaging.instance.subscribeToTopic(modelLogin.step!)
                : {};
            PrefsHelper.instance.saveDataAkun(modelAuth);
          } else {
            emit(AuthenticationProcessError(errorMessage: modelLogin.respMsg));
          }
        } catch (e) {
          emit(AuthenticationProcessError(errorMessage: e.toString()));
        }
      } else if (event is AuthenticationProcessEventSP) {
        ModelAuth? modelAuth = await PrefsHelper.instance.getDataAkun();
        if (modelAuth != null) {
          DateTime currentDate = DateTime.now();
          DateTime? loginDate = modelAuth.dateTimeLogin;
          if (loginDate != null) {
            int differenceInDays = currentDate.difference(loginDate).inDays;

            if (differenceInDays >= 3) {
              await PrefsHelper.instance.clearDataLogin();
              FirebaseMessaging.instance.unsubscribeFromTopic(modelAuth.picId);
              FirebaseMessaging.instance.unsubscribeFromTopic(modelAuth.step);
              emit(AuthenticationProcessInitial());
            } else {
              modelAuth = modelAuth.copyWith(dateTimeLogin: currentDate);
              PrefsHelper.instance.saveDataAkun(modelAuth);
              emit(AuthenticationProcessSuccess(modelAuth));
            }
          } else {
            modelAuth = modelAuth.copyWith(dateTimeLogin: currentDate);
            PrefsHelper.instance.saveDataAkun(modelAuth);
            emit(AuthenticationProcessSuccess(modelAuth));
          }
        } else {
          emit(AuthenticationProcessInitial());
        }
        // if (modelAuth != null) {
        //   emit(AuthenticationProcessSuccess(modelAuth));
        // } else {
        //   emit(AuthenticationProcessInitial());
        // }
      } else if (event is AuthenticationProcessEventLogout) {
        await PrefsHelper.instance.clearDataLogin();
        FirebaseMessaging.instance.unsubscribeFromTopic(event.modelAuth.picId);
        FirebaseMessaging.instance.unsubscribeFromTopic(event.modelAuth.step);
        emit(AuthenticationProcessInitial());
      } else if (event is AuthenticationProcessEventChangeUser) {
        ModelAuth modelAuth = event.modelAuth;
        emit(AuthenticationProcessSuccess(modelAuth));
        PrefsHelper.instance.saveDataAkun(modelAuth);
      }
    });
  }
}
