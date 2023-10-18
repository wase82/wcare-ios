import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/bloc/follow_up/follow_up_bloc.dart';
import 'package:wtoncare/bloc/photo_picker/photo_picker_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wtoncare/shared/widget/background.dart';
import 'package:wtoncare/shared/widget/detail_dialog.dart';
import 'package:wtoncare/shared/widget/image.dart';
import 'package:wtoncare/shared/widget/loading.dart';
import 'package:wtoncare/shared/widget/alert.dart';
import 'package:wtoncare/shared/util/validator.dart';
import 'package:wtoncare/shared/widget/textfield.dart';

class PageFollowUp extends StatefulWidget {
  final ModelDetailLaporan modelDetailLaporan;

  const PageFollowUp({Key? key, required this.modelDetailLaporan})
      : super(key: key);

  @override
  State<PageFollowUp> createState() => _PageFollowUpState();
}

class _PageFollowUpState extends State<PageFollowUp> {
  FollowUpBloc followUpBloc = FollowUpBloc();
  PhotoPickerBloc photoPickerBloc = PhotoPickerBloc();
  late AutoScrollController columnScroll;
  late ValueNotifier<String?> _fotoValidator;
  late ValueNotifier<String?> _titleValidator;
  String keterangan = "";

  @override
  void initState() {
    _fotoValidator = ValueNotifier<String?>('');
    _titleValidator = ValueNotifier<String?>('');
    columnScroll = AutoScrollController(axis: Axis.vertical);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => photoPickerBloc,
        ),
        BlocProvider(
          create: (context) => followUpBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/images/logo_wika.png",
            height: 36.0,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            const BG(),
            BlocConsumer<FollowUpBloc, FollowUpState>(
              listener: (context, state) {
                if (state is FollowUpSuccess) {
                  showSnackBar(
                    context: context,
                    message: "Tindak Lanjut Tersimpan",
                    messageType: MessageType.success,
                  );
                  Navigator.pop(context, true);
                }
              },
              builder: (context, state) {
                if (state is FollowUpLoading) {
                  return const Center(
                    child: LoadingWidget(message: "Menyimpan Tindak Lanjut"),
                  );
                } else if (state is FollowUpError) {
                  return ButtonReload(
                    function: () {
                      validate();
                    },
                    errorMessage: state.errorMessage,
                  );
                }
                return SingleChildScrollView(
                  controller: columnScroll,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetDetailLaporan(
                            modelDetailLaporan: widget.modelDetailLaporan,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Center(
                            child: Text(
                              "Form Tindak Lanjut",
                              style: TextStyle(
                                color: cSecondColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _wrapScrollTag(
                              child: CardImage(
                                photoPickerBloc: photoPickerBloc,
                                title: "Foto",
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              index: 0),
                          Align(
                            alignment: Alignment.center,
                            child: validatorMesage(_fotoValidator),
                          ),
                          _wrapScrollTag(
                            child: QTextField(
                              label: "Keterangan Tindak Lanjut",
                              hint: "Input Keterangan",
                              maxLine: 4,
                              value: "",
                              onChanged: (value) {
                                keterangan = value;
                              },
                            ),
                            index: 4,
                          ),
                          validatorMesage(_titleValidator),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cSecondColor,
                              ),
                              onPressed: () => validate(),
                              child: const Text(
                                "Kirim Tindak Lanjut",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    FocusScope.of(context).unfocus();
    PhotoPickerState photoPickerState = photoPickerBloc.state;
    bool isImage = imageValidator();
    bool isKeterangan = titleValidator(keterangan);
    if (!isImage) {
      columnScroll.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isKeterangan) {
      columnScroll.scrollToIndex(4, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (photoPickerState is PhotoPickerPhotoPicked) {
      DeviceBloc deviceBloc = context.read<DeviceBloc>();
      AuthenticationProcessBloc authBloc =
          context.read<AuthenticationProcessBloc>();
      AuthenticationProcessState authState = authBloc.state;
      if (authState is AuthenticationProcessSuccess) {
        followUpBloc.add(FollowUpEventKirimLaporan(
            modelAuth: authState.modelAuth,
            keterangan: keterangan,
            laporanId: widget.modelDetailLaporan.laporanId,
            deviceInitial: deviceBloc.state,
            fileFoto: photoPickerState.pickedPhoto));
      }
    }
  }

  bool imageValidator() {
    PhotoPickerState photoPickerState = photoPickerBloc.state;
    if (photoPickerState is! PhotoPickerPhotoPicked) {
      _fotoValidator.value = 'Ambil Foto';
      return false;
    }
    _fotoValidator.value = null;
    return true;
  }

  bool titleValidator(String? text) {
    if (text?.replaceAll(' ', '').isEmpty ?? false) {
      _titleValidator.value = 'Isi Keterangan';
      return false;
    }
    _titleValidator.value = null;
    return true;
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: columnScroll,
        index: index,
        highlightColor: Colors.black.withOpacity(0.1),
        child: child,
      );
}
