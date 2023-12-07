import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/cart_controller.dart';
import 'package:firebase_tutorial/views/cart_screen/payment_method.dart';
import 'package:firebase_tutorial/views/widgets_common/custom_textfield.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Thông tin đặt hàng"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.length > 10) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Hãy điền đẩy đủ thông tin");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Tiếp tục",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Địa chỉ",
                isPass: false,
                title: "Địa chỉ",
                controller: controller.addressController),
            customTextField(
              hint: "Tỉnh/Thành phố",
              isPass: false,
              title: "Tỉnh/Thành phố",
              controller: controller.cityController,
            ),
            customTextField(
              hint: "Quận/Huyện",
              isPass: false,
              title: "Quận/Huyện",
              controller: controller.districtController,
            ),
            customTextField(
              hint: "Phường",
              isPass: false,
              title: "Phường",
              controller: controller.wardController,
            ),
            customTextField(
              hint: "Số điện thoại",
              isPass: false,
              title: "Số điện thoại",
              controller: controller.phoneController,
            ),
          ],
        ),
      ),
    );
  }
}
