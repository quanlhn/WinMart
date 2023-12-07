import 'package:firebase_tutorial/consts/consts.dart';
import 'package:flutter/material.dart';

Widget orderStatus({icon, newColor, title, showDone}) {
  return ListTile(
    leading: Icon(
      icon,
      color: newColor,
    )
        .box
        .border(color: newColor)
        .roundedSM
        .padding(const EdgeInsets.all(4))
        .make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "$title".text.color(darkFontGrey).make(),
          showDone
              ? const Icon(
                  Icons.done,
                  color: redColor,
                )
              : Container(),
        ],
      ),
    ),
  );
}
