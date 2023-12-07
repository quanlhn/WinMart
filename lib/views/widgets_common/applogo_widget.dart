import 'package:firebase_tutorial/consts/consts.dart';
import 'package:flutter/material.dart';

Widget applogoWidget() {
  // su dung Velcoity X
  return Image.asset(icWinMartLogo)
      .box
      .white
      .size(80, 80)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
