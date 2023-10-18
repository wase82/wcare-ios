import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/services/services_bloc.dart';
import 'package:wtoncare/service/service.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/shared/util/validator.dart';
import 'package:wtoncare/shared/widget/alert.dart';
import 'package:wtoncare/shared/widget/background.dart';
import 'package:http/http.dart' as http;

class PageVerifyUser extends StatefulWidget {
  const PageVerifyUser({Key? key}) : super(key: key);

  @override
  State<PageVerifyUser> createState() => _PageVerifyUserState();
}

class _PageVerifyUserState extends State<PageVerifyUser> {
  TextEditingController nipController = TextEditingController();
  // TextEditingController nipController = TextEditingController(text: 'TX113174');
  late ValueNotifier<String?> _nipValidator;
  String namaApp = "";
  String versiApp = "";

  @override
  void initState() {
    _nipValidator = ValueNotifier<String?>('');
    getConfigData();
    super.initState();
  }

  void getConfigData() async {
    try {
      final config = await getConfig();
      setState(() {
        namaApp = config['app_name'];
        versiApp = "Versi ${config['version']}";
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationProcessBloc, AuthenticationProcessState>(
        listener: (context, state) {
          if (state is AuthenticationProcessVerifySuccess) {
            Navigator.pushNamed(
              context,
              '/pageOtp',
              arguments: {
                'username': nipController.text,
                'nama': state.nama,
                'waNumber': state.waNumber,
              },
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
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Image.asset(
                        'assets/images/logo_wton_care.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      const Text(
                        "Silahkan masukkan NIP Anda :",
                        style: TextStyle(
                            color: cMain, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color(0xff00aeef).withOpacity(0.2),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: nipController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan NIP',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      validatorMesage(_nipValidator),
                      const SizedBox(
                        height: 20.0,
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () async {
                                validate();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: cSecondColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Column(
                        children: [
                          Text(
                            namaApp,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            versiApp,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          const Text(
                            "2023",
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void validate() {
    String nip = nipController.text;
    bool isNIPTrue = nipValidator(nip);
    if (!isNIPTrue) {
      return;
    }
    FocusScope.of(context).unfocus();
    ServicesBloc servicesBloc = context.read<ServicesBloc>();
    servicesBloc.add(ServicesEventCheckPermission());
    context
        .read<AuthenticationProcessBloc>()
        .add(AuthenticationProcessVerify(nip));
  }

  bool nipValidator(String? text) {
    if (text == null || text.isEmpty) {
      _nipValidator.value = 'NIP tidak boleh kosong';
      return false;
    }

    _nipValidator.value = null;
    return true;
  }
}

Future<Map<String, dynamic>> getConfig() async {
  String strUrl = "${Service.mainApi}/wcare/configapp";
  Uri url = Uri.parse(strUrl);
  final response = await http
      .post(url, headers: Service.mainheader)
      .timeout(Service.durReq, onTimeout: () {
    return Future.error("timeout");
  }).onError((error, stackTrace) {
    if (error == "timeout") {
      throw APIService.timeout;
    } else {
      throw APIService.serverError;
    }
  });
  try {
    final data = json.decode(response.body);
    return data;
  } catch (e) {
    throw APIService.decodeError;
  }
}
