import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/orders_screen/orders_details.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Đơn hàng".text.color(darkFontGrey).fontFamily(bold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Chưa có đơn hàng đã đặt!"
                  .text
                  .color(darkFontGrey)
                  .makeCentered(),
            );
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index + 1}"
                      .text
                      .fontFamily(bold)
                      .color(darkFontGrey)
                      .xl
                      .make(),
                  title: "Mã đơn hàng: ${data[index]['order_code']}"
                      .toString()
                      .text
                      .color(redColor)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: data[index]['total_amount']
                      .toString()
                      .numCurrencyWithLocale(locale: "vi")
                      .text
                      .fontFamily(bold)
                      .make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => OrdersDetails(data: data[index]));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    color: darkFontGrey,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
