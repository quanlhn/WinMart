import 'package:firebase_tutorial/consts/colors.dart';
import 'package:flutter/material.dart';

Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
