import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/forward/forward_bloc.dart';
import 'package:wtoncare/bloc/laporan_detail/laporan_detail_bloc.dart';
import 'package:wtoncare/bloc/update_proses/update_proses_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:wtoncare/shared/widget/image.dart';
import 'package:wtoncare/shared/widget/loading.dart';
import 'package:wtoncare/shared/widget/richtext.dart';

Future<bool?> forwardingDialog(
    BuildContext context, ModelAuth modelAuth, String idLaporan) async {
  ForwardBloc forwardBloc = ForwardBloc();
  forwardBloc.add(ForwardEventForward(modelAuth, idLaporan));
  return await showDialog<bool?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BlocConsumer<ForwardBloc, ForwardState>(
        bloc: forwardBloc,
        listener: (context, state) {
          if (state is ForwardSuccess) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is ForwardError) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                controller: ScrollController(),
                child: ListBody(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    ButtonReload(
                        function: () {
                          forwardBloc
                              .add(ForwardEventForward(modelAuth, idLaporan));
                        },
                        errorMessage: state.errorMessage),
                  ],
                ),
              ),
            );
          }
          return const Loading();
        },
      );
    },
  );
}

Future<bool?> updatingStatusLaporanDialog(
    BuildContext context, ModelAuth modelAuth, String idLaporan) async {
  UpdateProsesBloc updateStatus = UpdateProsesBloc();
  updateStatus.add(UpdateProsesEventUpdateStatus(modelAuth, idLaporan));
  return await showDialog<bool?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BlocConsumer<UpdateProsesBloc, UpdateProsesState>(
        bloc: updateStatus,
        listener: (context, state) {
          if (state is UpdateProsesSuccess) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is UpdateProsesError) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    ButtonReload(
                        function: () {
                          updateStatus.add(
                            UpdateProsesEventUpdateStatus(modelAuth, idLaporan),
                          );
                        },
                        errorMessage: state.errorMessage)
                  ],
                ),
              ),
            );
          }
          return const Loading();
        },
      );
    },
  );
}

Future<bool?> askNowOrLater(BuildContext context) async {
  return await showDialog<bool?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Apakah anda ingin melaporkan tindak lanjut ?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              'Ya',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> askDiteruskan(BuildContext context) async {
  return await showDialog<bool?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Apakah anda yakin temuan ini akan diteruskan ke atasan anda ?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              'Ya',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

//Detail Laporanku
Future<ModelDetailLaporan?> detailDialogLaporanku(
    BuildContext context, ModelAuth modelAuth, String idLaporan) async {
  LaporanDetailBloc laporanDetailBloc = LaporanDetailBloc();
  laporanDetailBloc.add(LaporanDetailEventGetDetail(
      username: modelAuth.username, idLaporan: idLaporan));
  return await showDialog<ModelDetailLaporan?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BlocBuilder<LaporanDetailBloc, LaporanDetailState>(
        bloc: laporanDetailBloc,
        builder: (context, state) {
          if (state is LaporanDetailFailed) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                child: ButtonReload(
                  function: () {
                    laporanDetailBloc.add(
                      LaporanDetailEventGetDetail(
                        username: modelAuth.username,
                        idLaporan: idLaporan,
                      ),
                    );
                  },
                  errorMessage: state.errorMessage,
                ),
              ),
            );
          } else if (state is LaporanDetailSuccess) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              content: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListBody(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetDetailLaporan(
                                modelDetailLaporan: state.modelDetailLaporan,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: CircleAvatar(
                        backgroundColor: cWhite.withOpacity(0.5),
                        radius: 15,
                        child: const Icon(
                          Icons.close,
                          color: cError,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Loading();
        },
      );
    },
  );
}

Future<GoToDetail?> detailDialog(
    BuildContext context, ModelAuth modelAuth, String idLaporan) async {
  LaporanDetailBloc laporanDetailBloc = LaporanDetailBloc();
  laporanDetailBloc.add(LaporanDetailEventGetDetail(
      username: modelAuth.username, idLaporan: idLaporan));
  return await showDialog<GoToDetail?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BlocBuilder<LaporanDetailBloc, LaporanDetailState>(
        bloc: laporanDetailBloc,
        builder: (context, state) {
          if (state is LaporanDetailFailed) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                child: ButtonReload(
                  function: () {
                    laporanDetailBloc.add(LaporanDetailEventGetDetail(
                        username: modelAuth.username, idLaporan: idLaporan));
                  },
                  errorMessage: state.errorMessage,
                ),
              ),
            );
          } else if (state is LaporanDetailSuccess) {
            bool isOpen = false;
            bool isOnProcess = false;
            if (state.modelDetailLaporan.statusCode == 'O') {
              isOpen = true;
            } else if (state.modelDetailLaporan.statusCode == 'P') {
              isOnProcess = true;
            } else {
              isOpen = false;
              isOnProcess = false;
            }
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              WidgetDetailLaporan(
                                modelDetailLaporan: state.modelDetailLaporan,
                              ),
                              isOpen
                                  ? modelAuth.step ==
                                          state.modelDetailLaporan.step
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment: state
                                                        .modelDetailLaporan
                                                        .step !=
                                                    '3'
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: cSecondColor,
                                                ),
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    GoToDetail(
                                                        "followup",
                                                        state
                                                            .modelDetailLaporan)),
                                                child:
                                                    const Text("Tindak Lanjut"),
                                              ),
                                              state.modelDetailLaporan.step !=
                                                      '3'
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context,
                                                            GoToDetail(
                                                                "forward",
                                                                null));
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                              backgroundColor:
                                                                  cWarning),
                                                      child: const Text(
                                                        "Diteruskan",
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                  : isOnProcess
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: cSecondColor,
                                          ),
                                          onPressed: () => Navigator.pop(
                                              context,
                                              GoToDetail("gotofollowup",
                                                  state.modelDetailLaporan)),
                                          child: const Text("Tindak Lanjut"),
                                        )
                                      : const SizedBox(),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: CircleAvatar(
                        backgroundColor: cWhite.withOpacity(0.5),
                        radius: 15,
                        child: const Icon(
                          Icons.close,
                          color: cError,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Loading();
        },
      );
    },
  );
}

class WidgetDetailLaporan extends StatelessWidget {
  final ModelDetailLaporan modelDetailLaporan;

  const WidgetDetailLaporan({Key? key, required this.modelDetailLaporan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isClose = false;
    if (modelDetailLaporan.statusCode == "C") {
      isClose = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Foto Temuan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: cSecondColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        ImageNetworkHolderRadius(
          url: modelDetailLaporan.foto,
        ),
        const SizedBox(
          height: 5.0,
        ),
        CustomRichText(
          title: "No Register",
          content: modelDetailLaporan.noRegister,
        ),
        CustomRichText(
          title: "Tanggal",
          content: modelDetailLaporan.tanggal,
        ),
        CustomRichText(
          title: "Kriteria",
          content: modelDetailLaporan.kriteria,
        ),
        CustomRichText(
          title: "Uraian Temuan",
          content: modelDetailLaporan.deskripsi,
        ),
        CustomRichText(
          title: "Jumlah",
          content: modelDetailLaporan.jumlah,
        ),
        CustomRichText(
          title: "Lokasi",
          content: modelDetailLaporan.lokasi,
        ),
        CustomRichText(
          title: "PIC",
          content: modelDetailLaporan.pic,
        ),
        CustomRichText(
          title: "Kategori",
          content: modelDetailLaporan.kategori,
        ),
        CustomRichText(
          title: "Keparahan",
          content: modelDetailLaporan.keparahan,
        ),
        isClose
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Data Tindak Lanjut",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: cSecondColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ImageNetworkHolderRadius(
                    url: modelDetailLaporan.fotoTindak,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  CustomRichText(
                    title: "Tanggal",
                    content: modelDetailLaporan.tanggalTindakLanjut,
                  ),
                  CustomRichText(
                    title: "Keterangan",
                    content: modelDetailLaporan.keteranganTindak,
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}

class GoToDetail {
  final String router;
  final ModelDetailLaporan? modelDetailLaporan;

  GoToDetail(this.router, this.modelDetailLaporan);
}
