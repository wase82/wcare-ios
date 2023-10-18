import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';

class PageSplash extends StatefulWidget {
  const PageSplash({Key? key}) : super(key: key);

  @override
  State<PageSplash> createState() => _PageSplashState();
}

class _PageSplashState extends State<PageSplash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onInit());
    super.initState();
  }

  void onInit() {
    getToken();
  }

  getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      context.read<DeviceBloc>().add(DeviceEventAddToken(value));
      // print(value);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationProcessBloc, AuthenticationProcessState>(
      bloc: context.read<AuthenticationProcessBloc>()
        ..add(AuthenticationProcessEventSP()),
      listener: (context, state) {
        if (state is AuthenticationProcessSuccess) {
          Navigator.pushReplacementNamed(context, '/pageHome');
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/pageVerify');
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          child: Center(
            child: Image.asset(
              'assets/images/logo_wton_care.png',
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
