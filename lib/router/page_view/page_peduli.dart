import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wtoncare/bloc/laporanku/laporanku_bloc.dart';
import 'package:wtoncare/bloc/list_laporan/list_laporan_bloc.dart';
import 'package:wtoncare/bloc/performa/performa_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageViewPeduli extends StatefulWidget {
  final ModelAuth modelAuth;

  const PageViewPeduli({Key? key, required this.modelAuth}) : super(key: key);

  @override
  State<PageViewPeduli> createState() => _PageViewPeduliState();
}

class _PageViewPeduliState extends State<PageViewPeduli> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () async {
            bool isLocationServiceGranted = true;
            bool isCameraServiceGranted = true;
            bool isLocationOn = true;
            PermissionStatus cameraServiceStatus =
                await Permission.camera.status;
            PermissionStatus locationServiceStatus =
                await Permission.location.status;
            if (cameraServiceStatus != PermissionStatus.granted) {
              isCameraServiceGranted = false;
              cameraServiceStatus = await Permission.camera.request();
              if (cameraServiceStatus == PermissionStatus.granted) {
                isCameraServiceGranted = true;
              }
            }
            if (locationServiceStatus != PermissionStatus.granted) {
              isLocationServiceGranted = false;
              locationServiceStatus = await Permission.location.request();
              if (locationServiceStatus == PermissionStatus.granted) {
                isLocationServiceGranted = true;
              }
            }
            isLocationOn = await Geolocator.isLocationServiceEnabled();
            if (isLocationOn &&
                isCameraServiceGranted &&
                isLocationServiceGranted &&
                mounted) {
              Navigator.pushNamed(context, '/pageLaporPeduli',
                      arguments: widget.modelAuth)
                  .then((value) {
                if (value == true) {
                  context.read<ListLaporanBloc>().add(
                      ListLaporanEventReqList(widget.modelAuth, "", "", ""));
                  context
                      .read<LaporankuBloc>()
                      .add(LaporankuEventReqLaporan(widget.modelAuth));
                  context
                      .read<PerformaBloc>()
                      .add(PerformaEventReqPerforma(widget.modelAuth));
                }
              });
            } else {
              showAlert(isCameraServiceGranted, isLocationServiceGranted,
                  isLocationOn);
            }
          },
          style: TextButton.styleFrom(
              backgroundColor: cSecondColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Text(
            'Buat Laporan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const Spacer()
      ],
    );
  }

  showAlert(bool cameraService, bool locationServices, bool isLocationOn) {
    TextStyle styleError = const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.normal,
      color: cMain,
    );
    TextStyle styleErrorBold = const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
      color: cMain,
    );
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Layanan Aplikasi',
                textAlign: TextAlign.center,
              ),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.warning_sharp,
                          color: Colors.red, size: 25),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Builder(builder: (context) {
                    String permission = '';
                    if (!cameraService || !locationServices) {
                      permission =
                          "mambutuhkan ${(!cameraService && !locationServices ? 'kameran dan lokasi' : !cameraService ? 'kamera' : 'lokasi')} mengirim laporan";
                    } else if (!isLocationOn) {
                      permission =
                          "membutuhkan akses lokasi. Harap nyalakan GPS";
                    }
                    return Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: 'Aplikasi ',
                          style: styleErrorBold,
                          children: <TextSpan>[
                            TextSpan(text: permission, style: styleError),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  })
                ],
              ));
        });
  }
}
