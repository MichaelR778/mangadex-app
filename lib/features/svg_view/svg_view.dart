import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgView extends StatelessWidget {
  final String svgFileName;
  final String message;

  const SvgView({
    super.key,
    required this.svgFileName,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/vectors/$svgFileName.svg',
          width: MediaQuery.of(context).size.width / 1.7,
          height: MediaQuery.of(context).size.width / 1.7,
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.7,
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
