import 'package:flutter/material.dart';

class BG extends StatelessWidget {
  const BG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
