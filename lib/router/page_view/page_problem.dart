import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/bloc/laporanku/laporanku_bloc.dart';
import 'package:wtoncare/bloc/performa/performa_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/list_laporan/list_laporan_bloc.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wtoncare/shared/widget/datefield.dart';
import 'package:wtoncare/shared/widget/detail_dialog.dart';
import 'package:wtoncare/shared/widget/dropdown.dart';
import 'package:wtoncare/shared/widget/loading.dart';

class PageViewProblem extends StatefulWidget {
  final ModelAuth modelAuth;

  const PageViewProblem({Key? key, required this.modelAuth}) : super(key: key);

  @override
  State<PageViewProblem> createState() => _PageViewProblemState();
}

class _PageViewProblemState extends State<PageViewProblem> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  DateTime tgl = DateTime.now();
  late DateTime tglAwal;
  String dari = "";
  String sampai = "";
  String status = "O";

  @override
  void initState() {
    super.initState();
    tglAwal = DateTime(tgl.year, tgl.month, 1);
    dari = DateFormat('dd-MM-y').format(tglAwal);
    sampai = DateFormat('dd-MM-y').format(tgl);
  }

  void onRefresh() async {
    dari = DateFormat('dd-MM-y').format(tglAwal);
    sampai = DateFormat('dd-MM-y').format(tgl);
    context
        .read<ListLaporanBloc>()
        .add(ListLaporanEventReqList(widget.modelAuth, dari, sampai, "O"));
    Future.delayed(const Duration(milliseconds: 250));
    refreshController.refreshCompleted();
  }

  void onFilter() async {
    context
        .read<ListLaporanBloc>()
        .add(ListLaporanEventReqList(widget.modelAuth, dari, sampai, status));
    Future.delayed(const Duration(milliseconds: 250));
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      onRefresh: onRefresh,
      header: const WaterDropHeader(
        waterDropColor: cSecondColor,
      ),
      controller: refreshController,
      child: BlocBuilder<ListLaporanBloc, ListLaporanState>(
        builder: (context, state) {
          if (state is ListLaporanStateLoading) {
            return const Center(child: LoadingWidget());
          } else if (state is ListLaporanStateNoData) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cSecondColor,
                        ),
                        onPressed: () {
                          status = "O";
                          filterDialog();
                        },
                      ),
                      DateTimeFetch(
                        dateTime: state.dateTimeNow,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // DateTimeFetch(
                  //   dateTime: state.dateTimeNow,
                  // ),
                  const Expanded(
                    child: Center(
                        child: ErrorText(
                      errorMessage: "Belum ada laporan",
                    )),
                  ),
                ],
              ),
            );
          } else if (state is ListLaporanStateSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.filter_alt,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Filter",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cSecondColor,
                          ),
                          onPressed: () {
                            status = "O";
                            filterDialog();
                          },
                        ),
                        DateTimeFetch(
                          dateTime: state.dateTimeNow,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      children: [
                        Builder(builder: (context) {
                          return Column(
                            children: state.list.map(
                              (e) {
                                return Builder(
                                  builder: (context) {
                                    bool isOpen = false;
                                    bool isOnProcess = false;
                                    if (e.statusCode == 'O') {
                                      isOpen = true;
                                    } else if (e.statusCode == 'P') {
                                      isOnProcess = true;
                                    } else {
                                      isOpen = false;
                                      isOnProcess = false;
                                    }

                                    return GestureDetector(
                                      onTap: () async {
                                        detailDialog(context, widget.modelAuth,
                                                e.laporanId)
                                            .then((asd) {
                                          if (asd is GoToDetail) {
                                            if (asd.router == "followup") {
                                              askNowOrLater(context)
                                                  .then((value) {
                                                if (value == true) {
                                                  updatingStatusLaporanDialog(
                                                          context,
                                                          widget.modelAuth,
                                                          e.laporanId)
                                                      .then(
                                                    (value) async {
                                                      if (value == true) {
                                                        gotoFollowUp(asd
                                                            .modelDetailLaporan!);
                                                      }
                                                      onRefresh();
                                                    },
                                                  );
                                                }
                                              });
                                            } else if (asd.router ==
                                                "forward") {
                                              askDiteruskan(context)
                                                  .then((value) {
                                                if (value == true) {
                                                  forwardingDialog(
                                                          context,
                                                          widget.modelAuth,
                                                          e.laporanId)
                                                      .then(
                                                    (value) {
                                                      if (value == true) {
                                                        context
                                                            .read<
                                                                ListLaporanBloc>()
                                                            .add(
                                                              ListLaporanEventReqList(
                                                                widget
                                                                    .modelAuth,
                                                                dari,
                                                                sampai,
                                                                status,
                                                              ),
                                                            );
                                                      }
                                                    },
                                                  );
                                                }
                                              });
                                            } else if (asd.router ==
                                                "gotofollowup") {
                                              gotoFollowUp(
                                                  asd.modelDetailLaporan!);
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          gradient: isOpen
                                              ? cGradientError
                                              : isOnProcess
                                                  ? cGradientWarning
                                                  : cGradientSuccess,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.kriteria,
                                              style: const TextStyle(
                                                  color: cWhite,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              e.keterangan,
                                              style: const TextStyle(
                                                  fontSize: 12, color: cWhite),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                              child: Divider(
                                                color: cWhite,
                                                thickness: 1,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 50,
                                                          child: Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "Terkirim\n",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        cWhite,
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: "Waktu",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        cWhite,
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    ': ${e.tanggal}\n',
                                                                style:
                                                                    const TextStyle(
                                                                  color: cWhite,
                                                                  fontSize:
                                                                      10.0,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    ': ${e.waktu}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: cWhite,
                                                                  fontSize:
                                                                      10.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 2,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: cWhite,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        8.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    e.status,
                                                    style: TextStyle(
                                                      color: isOpen
                                                          ? cError
                                                          : isOnProcess
                                                              ? cWarning
                                                              : cSuccess,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ).toList(),
                          );
                        }),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void gotoFollowUp(ModelDetailLaporan modelDetailLaporan) {
    Navigator.pushNamed(context, '/pageFollowUp', arguments: modelDetailLaporan)
        .then((value) {
      if (value == true) {
        context.read<ListLaporanBloc>().add(
            ListLaporanEventReqList(widget.modelAuth, dari, sampai, status));
        context
            .read<LaporankuBloc>()
            .add(LaporankuEventReqLaporan(widget.modelAuth));
        context
            .read<PerformaBloc>()
            .add(PerformaEventReqPerforma(widget.modelAuth));
      }
    });
  }

  filterDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15.0,
                            ),
                            QDatePicker(
                              label: "Dari",
                              value: tglAwal,
                              onChanged: (value) {
                                dari = DateFormat('dd-MM-y').format(value);
                              },
                            ),
                            QDatePicker(
                              label: "Sampai",
                              value: tgl,
                              onChanged: (value) {
                                sampai = DateFormat('dd-MM-y').format(value);
                              },
                            ),
                            QDropdownField(
                              hint: 'OPEN',
                              hintText: '',
                              label: "Status",
                              items: const [
                                {
                                  "label": "OPEN",
                                  "value": "O",
                                },
                                {
                                  "label": "ON PROCESS",
                                  "value": "P",
                                },
                                {
                                  "label": "CLOSE",
                                  "value": "C",
                                }
                              ],
                              onChanged: (value, label) {
                                status = value;
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: cSecondColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: cSecondColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onFilter();
                                },
                                child: const Text(
                                  "Filter",
                                  style: TextStyle(
                                    color: cWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    backgroundColor: cUnFocusColor.withOpacity(0.5),
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
      },
    );
  }
}
