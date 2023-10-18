import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

class CustomRichText extends StatelessWidget {
  final String title;
  final String content;
  final Color? titleColor;
  final Color? contentColor;

  const CustomRichText({
    super.key,
    required this.title,
    required this.content,
    this.titleColor = cUnFocusColor,
    this.contentColor = cFourthColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: '$title :\n',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: titleColor,
          ),
          children: <TextSpan>[
            TextSpan(
              text: content,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
