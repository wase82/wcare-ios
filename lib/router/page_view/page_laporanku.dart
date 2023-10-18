import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/bloc/laporanku/laporanku_bloc.dart';
import 'package:wtoncare/shared/widget/detail_dialog.dart';
import 'package:wtoncare/shared/widget/loading.dart';

class PageViewLaporanku extends StatefulWidget {
  final ModelAuth modelAuth;

  const PageViewLaporanku({Key? key, required this.modelAuth})
      : super(key: key);

  @override
  State<PageViewLaporanku> createState() => _PageViewLaporankuState();
}

class _PageViewLaporankuState extends State<PageViewLaporanku> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    context
        .read<LaporankuBloc>()
        .add(LaporankuEventReqLaporan(widget.modelAuth));
    Future.delayed(const Duration(milliseconds: 250));
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        onRefresh: onRefresh,
        header: const WaterDropHeader(),
        controller: refreshController,
        child: BlocBuilder<LaporankuBloc, LaporankuState>(
          builder: (context, state) {
            if (state is LaporankuStateLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is LaporankuStateNoData) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    DateTimeFetch(
                      dateTime: state.dateTimeNow,
                    ),
                    const Expanded(
                      child: Center(
                          child: ErrorText(
                        errorMessage: "Belum ada laporan",
                      )),
                    ),
                  ],
                ),
              );
            } else if (state is LaporankuStateSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      DateTimeFetch(
                        dateTime: state.dateTimeNow,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: [
                          Builder(builder: (context) {
                            return Column(
                              children: state.listku.map(
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
                                        onTap: () {
                                          detailDialogLaporanku(context,
                                              widget.modelAuth, e.laporanId);
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
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                e.keterangan,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: cWhite),
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
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                    text:
                                                                        "Waktu",
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
                                                                    color:
                                                                        cWhite,
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      ': ${e.waktu}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        cWhite,
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
                                                    margin:
                                                        const EdgeInsets.only(
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
            return Container();
          },
        ));
  }
}
