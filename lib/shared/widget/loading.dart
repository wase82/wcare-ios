import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/shared/util/color.dart';

DateFormat dateFormat = DateFormat("d MMMM yyyy, HH:mm");
DateFormat dateFormatCard = DateFormat("dd/MM/yy HH:mm");
DateFormat dateFormatCardShort = DateFormat("dd/MM/yy");
DateFormat dateFormatFromApi = DateFormat("dd-MM-yyyy");
DateFormat dateFormatApi = DateFormat("dd-MM-yyyy HH:mm:ss");

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCube(
      color: cSecondColor,
      size: 70.0,
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpinKitFadingCube(
          color: cSecondColor,
          size: 50.0,
        ),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message ?? 'Mengambil data . . .',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: cUnFocusColor,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class DateTimeFetch extends StatelessWidget {
  final DateTime dateTime;

  const DateTimeFetch({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '*diupdate ${dateFormat.format(dateTime)}',
        style: const TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: cUnFocusColor,
        ),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String errorMessage;

  const ErrorText({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ButtonReload extends StatelessWidget {
  final Function function;
  final String errorMessage;

  const ButtonReload(
      {Key? key, required this.function, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: cError,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          SizedBox(
            height: 45,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.replay_outlined),
              label: const Text("Coba Lagi"),
              style: OutlinedButton.styleFrom(
                foregroundColor: cSecondColor,
                side: const BorderSide(
                  color: cSecondColor,
                ),
                shape: const StadiumBorder(),
              ),
              onPressed: () => function(),
            ),
          ),
        ],
      ),
    );
  }
}
