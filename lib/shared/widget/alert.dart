import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

enum MessageType { error, success, regular }

enum MessageDur { short, medium, long }

void showSnackBar({
  required BuildContext context,
  required String message,
  MessageType messageType = MessageType.regular,
  MessageDur messageDur = MessageDur.medium,
}) {
  final snackBar = SnackBar(
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/logo_wika.png',
          height: 25,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: cWhite,
            ),
          ),
        ),
      ],
    ),
    duration: messageDur == MessageDur.short
        ? const Duration(seconds: 1)
        : messageDur == MessageDur.medium
            ? const Duration(seconds: 2, milliseconds: 500)
            : const Duration(seconds: 4),
    backgroundColor: messageType == MessageType.regular
        ? cSecondColor
        : messageType == MessageType.success
            ? cSuccess
            : cError,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(
      left: 10,
      right: 10,
      bottom: 30.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
