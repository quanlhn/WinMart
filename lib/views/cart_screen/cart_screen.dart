import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/cart_controller.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/cart_screen/shipping_screen.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Gọi controller
    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          color: redColor,
          onPress: () {
            Get.to(() => const ShippingDetails());
          },
          textColor: whiteColor,
          title: "ĐẶT HÀNG",
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Giỏ hàng".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),

      /// Tạo StreamBuild lấy dữ liệu từ Firebase
      body: StreamBuilder(

          /// Lấy dữ liệu từ csdl carts theo uid
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              /// Nếu không có data:
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              /// Nếu csdl trống:
              return Center(
                child: "Giỏ hàng đang trống".text.color(darkFontGrey).make(),
              );
            } else {
              /// Lấy data:
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;

              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Image.network(
                              "${data[index]['img']}",
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            title:
                                "${data[index]['title']} (x${data[index]['qty']})"
                                    .text
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                            subtitle: "${data[index]['tprice']}"
                                .numCurrencyWithLocale(locale: "vi")
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),

                            /// Xử lý nút Xóa item trong màn "Giỏ hàng"
                            trailing: const Icon(
                              Icons.delete,
                              color: redColor,
                            ).onTap(() {
                              FirestoreServices.deleteDocument(data[index].id);
                            }),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Tổng giá tiền "
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        Obx(
                          () => "${controller.totalPrice.value}"
                              .numCurrencyWithLocale(locale: "vi")
                              .text
                              .fontFamily(semibold)
                              .color(redColor)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .color(lightGolden)
                        .width(context.screenWidth - 60)
                        .roundedSM
                        .make(),
                    10.heightBox,

                    /// Button
                    // SizedBox(
                    //   width: context.screenWidth - 60,
                    //   child: ourButton(
                    //     color: redColor,
                    //     onPress: () {},
                    //     textColor: whiteColor,
                    //     title: "ĐẶT HÀNG",
                    //   ),
                    // ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
