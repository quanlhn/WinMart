import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        const Divider(),
        10.heightBox,
        "Bạn có chắc chắn muốn thoát không?"
            .text
            .size(16)
            .color(darkFontGrey)
            .make(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(
              color: redColor,
              onPress: () {
                SystemNavigator.pop();
              },
              textColor: whiteColor,
              title: "Yes",
            ),
            ourButton(
              color: redColor,
              onPress: () {
                Navigator.pop(context);
              },
              textColor: whiteColor,
              title: "No",
            ),
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
