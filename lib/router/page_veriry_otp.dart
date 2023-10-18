import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/shared/util/validator.dart';
import 'package:wtoncare/shared/widget/alert.dart';
import 'package:wtoncare/shared/widget/background.dart';

class PageVerifyOtp extends StatefulWidget {
  final String username;
  final String nama;
  final String waNumber;

  const PageVerifyOtp(
      {Key? key,
      required this.username,
      required this.nama,
      required this.waNumber})
      : super(key: key);

  @override
  State<PageVerifyOtp> createState() => _PageVerifyOtpState();
}

class _PageVerifyOtpState extends State<PageVerifyOtp> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  late ValueNotifier<String?> _otpValidator;

  @override
  void initState() {
    _otpValidator = ValueNotifier<String?>('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo_wika.png",
          height: 36.0,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        toolbarHeight: 60,
      ),
      body: BlocBuilder<DeviceBloc, DeviceInitial>(
        builder: (context, deviceState) {
          return BlocConsumer<AuthenticationProcessBloc,
              AuthenticationProcessState>(
            listener: (context, state) {
              if (state is AuthenticationProcessSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/pageHome',
                  (route) => false,
                );
              } else if (state is AuthenticationProcessError) {
                showSnackBar(
                    context: context,
                    message: state.errorMessage,
                    messageType: MessageType.error);
              }
            },
            builder: (context, state) {
              bool isLoading = false;
              if (state is AuthenticationProcessLoading) {
                isLoading = true;
              }
              return Stack(
                children: [
                  const BG(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Masukkan Kode OTP",
                        style: TextStyle(
                          color: cMain,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        widget.nama,
                        style: const TextStyle(
                          color: cSecondColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Kode OTP dikirim ke ${widget.waNumber}",
                        style: const TextStyle(color: cMain),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color(0xff00aeef).withOpacity(0.2),
                              ),
                              child: TextFormField(
                                controller: otp1Controller,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color(0xff00aeef).withOpacity(0.2),
                              ),
                              child: TextFormField(
                                controller: otp2Controller,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color(0xff00aeef).withOpacity(0.2),
                              ),
                              child: TextFormField(
                                controller: otp3Controller,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color(0xff00aeef).withOpacity(0.2),
                              ),
                              child: TextFormField(
                                controller: otp4Controller,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      validatorMesage(_otpValidator),
                      const SizedBox(
                        height: 30.0,
                      ),
                      isLoading
                          ? const Align(
                              alignment: Alignment.topCenter,
                              child: CircularProgressIndicator(),
                            )
                          : Align(
                              alignment: Alignment.topCenter,
                              child: TextButton(
                                onPressed: () => validate(deviceState.token),
                                style: TextButton.styleFrom(
                                  backgroundColor: cSecondColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Verifikasi',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void validate(String token) {
    String otp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;
    bool isOtpTrue = otpValidator(otp);
    if (!isOtpTrue) {
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<AuthenticationProcessBloc>().add(
          AuthenticationProcessEventLogin(
            userName: widget.username,
            token: otp,
            tokenfirebase: token,
          ),
        );
  }

  bool otpValidator(String? text) {
    if (text == null || text.isEmpty) {
      _otpValidator.value = 'Kode OTP tidak boleh kosong';
      return false;
    }

    _otpValidator.value = null;
    return true;
  }
}
