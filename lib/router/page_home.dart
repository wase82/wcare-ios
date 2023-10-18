import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/laporanku/laporanku_bloc.dart';
import 'package:wtoncare/bloc/list_laporan/list_laporan_bloc.dart';
import 'package:wtoncare/bloc/performa/performa_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/main.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:wtoncare/router/page_view/page_laporanku.dart';
import 'package:wtoncare/router/page_view/page_performance.dart';
import 'package:wtoncare/router/page_view/page_problem.dart';
import 'package:wtoncare/shared/widget/background.dart';
import 'package:wtoncare/shared/widget/detail_dialog.dart';
import 'package:wtoncare/shared/widget/alert.dart';
import 'router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Style extends StyleHook {
  @override
  double get activeIconSize => 45;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 28;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      color: color,
      fontSize: 13,
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int curPage = 0;
  late TabController tabController;
  String judul = "Problem Lists";
  bool isLokasi = false;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => onInit());
    super.initState();
  }

  void onInit() {
    AuthenticationProcessBloc authenticationProcessBloc =
        context.read<AuthenticationProcessBloc>();
    AuthenticationProcessState state = authenticationProcessBloc.state;
    if (state is AuthenticationProcessSuccess) {
      context
          .read<ListLaporanBloc>()
          .add(ListLaporanEventReqList(state.modelAuth, "", "", ""));
      context
          .read<LaporankuBloc>()
          .add(LaporankuEventReqLaporan(state.modelAuth));
      context
          .read<PerformaBloc>()
          .add(PerformaEventReqPerforma(state.modelAuth));
    }
    _configureSelectNotificationSubject();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      if (currentRoute.toLowerCase() == "/pagehome") {
        if (payload?.isNotEmpty ?? false) {
          onSelectNotification(payload!);
        }
      } else {
        showSnackBar(
            context: context,
            message: "Ada Laporan Baru",
            messageType: MessageType.success);
        onChangePage(0);
        tabController.animateTo(0,
            curve: Curves.linear, duration: const Duration(milliseconds: 200));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationProcessBloc, AuthenticationProcessState>(
      listener: (context, state) {
        if (state is! AuthenticationProcessSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/pageVerify', (Route<dynamic> route) => false);
        }
      },
      builder: (context, userState) {
        if (userState is AuthenticationProcessSuccess) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              title: Text(judul),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/logo_wika.png",
                        height: 32.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          settingDialog(userState.modelAuth).then((value) {
                            if (value == 'logout') {
                              context.read<AuthenticationProcessBloc>().add(
                                  AuthenticationProcessEventLogout(
                                      userState.modelAuth));
                            } else if (value == 'edit') {
                              Navigator.pushNamed(context, '/pageEditData',
                                  arguments: userState.modelAuth);
                            } else if (value == "photo") {
                              Navigator.pushNamed(context, '/pageEditPhoto');
                            } else if (value == 'password') {
                              Navigator.pushNamed(
                                      context, '/pageChangePassword')
                                  .then((value) {
                                if (value == true) {
                                  context.read<AuthenticationProcessBloc>().add(
                                        AuthenticationProcessEventLogout(
                                            userState.modelAuth),
                                      );
                                }
                              });
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cSecondColor.withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              userState.modelAuth.avatar,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                const BG(),
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            PageViewProblem(modelAuth: userState.modelAuth),
                            const Text(""),
                            // PageLaporPeduli(modelAuth: userState.modelAuth),
                            PageViewLaporanku(modelAuth: userState.modelAuth),
                            PageViewPerfomance(modelAuth: userState.modelAuth)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: StyleProvider(
              style: Style(),
              child: ConvexAppBar(
                height: 58,
                top: -25,
                curveSize: 100,
                style: TabStyle.react,
                initialActiveIndex: curPage,
                controller: tabController,
                onTap: (int i) {
                  onChangePage(i);
                  if (i == 0) {
                    judul = "Problem Lists";
                  } else if (i == 1) {
                    Navigator.pushReplacementNamed(context, '/pageLaporPeduli',
                            arguments: userState.modelAuth)
                        .then((value) {
                      if (value == true) {
                        context.read<ListLaporanBloc>().add(
                            ListLaporanEventReqList(
                                userState.modelAuth, "", "", ""));
                        context
                            .read<LaporankuBloc>()
                            .add(LaporankuEventReqLaporan(userState.modelAuth));
                        context
                            .read<PerformaBloc>()
                            .add(PerformaEventReqPerforma(userState.modelAuth));
                      }
                    });
                  } else if (i == 2) {
                    judul = "My Report";
                  } else if (i == 3) {
                    judul = "Performance";
                  }
                  setState(() {});
                },
                items: [
                  TabItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SvgPicture.asset(
                        "assets/icons/document.svg",
                        colorFilter: const ColorFilter.mode(
                          cWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: "Problems",
                  ),
                  TabItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SvgPicture.asset(
                        "assets/icons/camera.svg",
                        colorFilter: const ColorFilter.mode(
                          cWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: "CARE",
                  ),
                  TabItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SvgPicture.asset(
                        "assets/icons/exclamation.svg",
                        colorFilter: const ColorFilter.mode(
                          cWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: "My Report",
                  ),
                  TabItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SvgPicture.asset(
                        "assets/icons/chart-line-up.svg",
                        colorFilter: const ColorFilter.mode(
                          cWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: "Performance",
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void onSelectNotification(String laporanId) {
    AuthenticationProcessBloc authenticationProcessBloc =
        context.read<AuthenticationProcessBloc>();
    AuthenticationProcessState state = authenticationProcessBloc.state;
    if (state is AuthenticationProcessSuccess) {
      detailDialog(context, state.modelAuth, laporanId).then((asd) {
        if (asd is GoToDetail) {
          if (asd.router == "followup") {
            updatingStatusLaporanDialog(context, state.modelAuth, laporanId)
                .then(
              (value) async {
                if (value == true) {
                  askNowOrLater(context).then((value) {
                    if (value == true) {
                      gotoFollowUp(asd.modelDetailLaporan!, state.modelAuth);
                    }
                  });
                }
              },
            );
          } else if (asd.router == "forward") {
            forwardingDialog(context, state.modelAuth, laporanId).then(
              (value) {
                if (value == true) {
                  context.read<ListLaporanBloc>().add(
                      ListLaporanEventReqList(state.modelAuth, "", "", ""));
                }
              },
            );
          } else if (asd.router == "gotofollowup") {
            gotoFollowUp(asd.modelDetailLaporan!, state.modelAuth);
          }
        }
      });
    }
  }

  void gotoFollowUp(
      ModelDetailLaporan modelDetailLaporan, ModelAuth modelAuth) {
    Navigator.pushNamed(context, '/pageFollowUp', arguments: modelDetailLaporan)
        .then((value) {
      if (value == true) {
        context
            .read<ListLaporanBloc>()
            .add(ListLaporanEventReqList(modelAuth, "", "", ""));
        context.read<LaporankuBloc>().add(LaporankuEventReqLaporan(modelAuth));
        context.read<PerformaBloc>().add(PerformaEventReqPerforma(modelAuth));
      }
    });
  }

  void onChangePage(int nextPage) {
    curPage = nextPage;
    _pageController.animateToPage(curPage,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  Future<String?> settingDialog(ModelAuth modelAuth) async {
    return showDialog<String?>(
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
                      height: MediaQuery.of(context).size.height * 0.14,
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: AssetImage("assets/images/bg.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 25,
                            left: 15,
                            child: CircleAvatar(
                              radius: 32.0,
                              backgroundImage: NetworkImage(
                                modelAuth.avatar,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            right: 0,
                            child: SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    modelAuth.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    modelAuth.level,
                                    style: const TextStyle(
                                      color: cUnFocusColor,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bagian",
                            style: TextStyle(
                              fontSize: 12,
                              color: cUnFocusColor,
                            ),
                          ),
                          Text(modelAuth.bagian),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text(
                            "Unit",
                            style: TextStyle(
                              fontSize: 12,
                              color: cUnFocusColor,
                            ),
                          ),
                          Text(modelAuth.unitNama),
                          const SizedBox(
                            height: 25.0,
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
                                backgroundColor: cError.withOpacity(0.1),
                              ),
                              onPressed: () => Navigator.pop(context, 'logout'),
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: cError,
                                ),
                              ),
                            ),
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
