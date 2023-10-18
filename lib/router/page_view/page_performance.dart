import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/performa/performa_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wtoncare/model/model_perform_keparahan.dart';
import 'package:wtoncare/model/model_perform_kriteria.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_perfom.dart';
import 'package:wtoncare/shared/widget/loading.dart';

TextStyle mainStyle = const TextStyle(
  color: cMain,
  fontFamily: 'Poppins',
  fontSize: 11,
);
TextStyle titleStyle = const TextStyle(
  color: cMain,
  fontFamily: 'Poppins',
  fontSize: 11,
  fontWeight: FontWeight.w500,
);
TextStyle chartStyle = const TextStyle(
  color: cWhite,
  fontFamily: 'Poppins',
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle tooltipStyle = const TextStyle(
  color: cWhite,
  fontFamily: 'Poppins',
);

class PageViewPerfomance extends StatefulWidget {
  final ModelAuth modelAuth;

  const PageViewPerfomance({Key? key, required this.modelAuth})
      : super(key: key);

  @override
  State<PageViewPerfomance> createState() => _PageViewPerfomanceState();
}

class _PageViewPerfomanceState extends State<PageViewPerfomance> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    context
        .read<PerformaBloc>()
        .add(PerformaEventReqPerforma(widget.modelAuth));
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
      child: BlocBuilder<PerformaBloc, PerformaState>(
        builder: (context, state) {
          if (state is PerformaStateLoading) {
            return const Center(child: LoadingWidget());
          } else if (state is PerformaStateNoData) {
            return Center(
              child: Column(
                children: [
                  DateTimeFetch(
                    dateTime: state.dateTimeNow,
                  ),
                  const Expanded(
                    child: Center(
                        child: ErrorText(
                      errorMessage: "Performa Kosong",
                    )),
                  ),
                ],
              ),
            );
          } else if (state is PerformaStateSuccess) {
            List<Detail> data = state.detail;
            List<DetailKriteria> dataKriteria = state.detailKriteria;
            List<DetailKeparahan> dataKeparahan = state.detailKeparahan;
            double persen = double.parse(state.persen);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateTimeFetch(
                    dateTime: state.dateTimeNow,
                  ),
                  Text(
                    "Hi, ${widget.modelAuth.nama}",
                    style: const TextStyle(
                      color: cSecondColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 130,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Temuan\n",
                                      ),
                                      TextSpan(
                                        text: "Terselesaikan",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: ': ${state.totalTemuan}\n'),
                                    TextSpan(
                                        text: ': ${state.totalTemuanSelesai}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xff00aeef),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "$persen%",
                            textScaleFactor: 1,
                            style: const TextStyle(
                              color: cWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        axisLine: const AxisLine(color: cMain),
                        labelStyle: mainStyle,
                      ),
                      primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(color: cMain),
                          labelStyle: mainStyle),
                      title: ChartTitle(
                        text: 'Prosentase Kecepatan Tindak Lanjut',
                        textStyle: titleStyle,
                      ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        textStyle: tooltipStyle,
                      ),
                      onTooltipRender: (arg) {
                        arg.header = "Pengerjaan";
                      },
                      series: <ChartSeries<Detail, String>>[
                        ColumnSeries<Detail, String>(
                          dataSource: data,
                          xValueMapper: (Detail sales, _) => sales.prosentase,
                          yValueMapper: (Detail sales, _) => sales.total,
                          isVisibleInLegend: false,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: chartStyle,
                          ),
                          color: cSecondColor,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        axisLine: const AxisLine(color: cMain),
                        labelStyle: mainStyle,
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(color: cMain),
                        labelStyle: mainStyle,
                      ),
                      title: ChartTitle(
                        text: 'Grafik Kriteria Temuan',
                        textStyle: titleStyle,
                      ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        textStyle: tooltipStyle,
                      ),
                      onTooltipRender: (arg) {
                        arg.header = "Kriteria";
                      },
                      series: <ChartSeries<DetailKriteria, String>>[
                        ColumnSeries<DetailKriteria, String>(
                          dataSource: dataKriteria,
                          xValueMapper: (DetailKriteria sales, _) =>
                              sales.kriteria,
                          yValueMapper: (DetailKriteria sales, _) =>
                              sales.total,
                          isVisibleInLegend: false,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: chartStyle,
                          ),
                          color: cWarning,
                        )
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        axisLine: const AxisLine(color: cMain),
                        labelStyle: mainStyle,
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(color: cMain),
                        labelStyle: mainStyle,
                      ),
                      title: ChartTitle(
                        text: 'Grafik Tingkat Keparahan',
                        textStyle: titleStyle,
                      ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        textStyle: tooltipStyle,
                      ),
                      onTooltipRender: (arg) {
                        arg.header = "Tingkat Keparahan";
                      },
                      series: <ChartSeries<DetailKeparahan, String>>[
                        ColumnSeries<DetailKeparahan, String>(
                          dataSource: dataKeparahan,
                          xValueMapper: (DetailKeparahan sales, _) =>
                              sales.level,
                          yValueMapper: (DetailKeparahan sales, _) =>
                              sales.total,
                          isVisibleInLegend: false,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: chartStyle,
                          ),

                          color: Colors
                              .transparent, // Mengatur warna dasar grafik menjadi transparan
                          pointColorMapper: (DetailKeparahan sales, _) {
                            if (sales.level == "1") {
                              return Color(int.parse(sales.warna));
                            } else if (sales.level == "2") {
                              return Color(int.parse(sales.warna));
                            } else if (sales.level == "3") {
                              return Color(int.parse(sales.warna));
                            } else if (sales.level == "4") {
                              return Color(int.parse(sales.warna));
                            } else if (sales.level == "5") {
                              return Color(int.parse(sales.warna));
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "Keterangan :",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dataKeparahan.map((item) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                            child: Text(
                              item.level,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                              child: Text(
                            item.nama,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
