import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

ValueListenableBuilder<String?> validatorMesage(ValueNotifier<String?> value) {
  return ValueListenableBuilder<String?>(
    valueListenable: value,
    builder: (context, val, _) {
      return Text(
        val ?? '',
        style: const TextStyle(
          color: cError,
          fontSize: 12,
        ),
        maxLines: 1,
        textAlign: TextAlign.center,
      );
    },
  );
}
