import 'package:flutter/material.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_detail_laporan.dart';
import 'package:wtoncare/router/page_home.dart';
import 'package:wtoncare/router/page_splash.dart';
import 'package:wtoncare/router/page_veriry_otp.dart';
import 'package:wtoncare/router/page_veriry_user.dart';
import 'package:wtoncare/router/page_view/page_lapor_peduli.dart';
import 'page_view/page_follow_up.dart';

String currentRoute = "";

class MyRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;
    currentRoute = settings.name ?? '';
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PageSplash());
      case '/pageHome':
        return MaterialPageRoute(builder: (_) => const PageHome());

      case '/pageLaporPeduli':
        if (args is ModelAuth) {
          return MaterialPageRoute(
              builder: (_) => PageLaporPeduli(modelAuth: args));
        }
        return _errorRoute();
      case '/pageFollowUp':
        if (args is ModelDetailLaporan) {
          return MaterialPageRoute(
              builder: (_) => PageFollowUp(
                    modelDetailLaporan: args,
                  ));
        }
        return _errorRoute();

      case '/pageVerify':
        return MaterialPageRoute(builder: (_) => const PageVerifyUser());
      case '/pageOtp':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        String username = arguments['username'];
        String nama = arguments['nama'];
        String waNumber = arguments['waNumber'];
        return MaterialPageRoute(
          builder: (_) =>
              PageVerifyOtp(username: username, nama: nama, waNumber: waNumber),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Whoops',
            textAlign: TextAlign.center,
          ),
        ),
        body: const Center(
          child: Text(
            "Couldn't find page\n"
            "or page is still under construction.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
  final Duration? duration;

  CustomPageRoute(
      {required this.child,
      this.direction = AxisDirection.right,
      this.duration,
      RouteSettings? settings})
      : super(
            transitionDuration: duration ?? const Duration(milliseconds: 600),
            reverseTransitionDuration:
                duration ?? const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) => child,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero)
          .animate(animation),
      child: child,
    );
    //   ScaleTransition(
    //   scale: animation,
    //   child: child,
    // );
  }

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
