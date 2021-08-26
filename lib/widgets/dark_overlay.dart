import 'package:flutter/material.dart';
import 'package:pizzamenu/values/values.dart';

class DarkOverLay extends StatelessWidget {
  final Gradient gradient;

  DarkOverLay({
    this.gradient = Gradients.footerOverlayGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Container(),
      ),
    );
  }
}
