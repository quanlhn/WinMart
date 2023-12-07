import 'package:firebase_tutorial/consts/consts.dart';
import 'package:flutter/widgets.dart';

Widget orderPlaceDetails({title1, title2, detail1, detail2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title1".text.fontFamily(semibold).make(),
              "$detail1".text.color(redColor).fontFamily(semibold).make(),
            ],
          ),
        ),
        SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              "$title2".text.fontFamily(semibold).make(),
              "$detail2".text.make(),
            ],
          ),
        ),
      ],
    ),
  );
}
