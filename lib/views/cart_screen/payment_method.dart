import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/consts/lists.dart';
import 'package:firebase_tutorial/controller/cart_controller.dart';
import 'package:firebase_tutorial/views/home_screen/home.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(child: loadingIndicator())
              : ourButton(
                  onPress: () async {
                    await controller.placeMyOrder(
                      orderPaymentMethod:
                          paymentMethods[controller.paymentIndex.value],
                      totalAmount: controller.totalPrice.value,
                    );
                    await controller.clearCart();
                    VxToast.show(context, msg: "Đặt hàng thành công!");

                    Get.offAll(const Home());
                  },
                  color: redColor,
                  textColor: whiteColor,
                  title: "XÁC NHẬN ĐẶT HÀNG",
                ),
        ),
        appBar: AppBar(
          title: "Phương thức thanh toán"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              /// Tạo danh sách "Phương thức thanh toán"
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  /// xử lý sự kiện khi ấn vào phần tử trong danh sách
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          /// Khi check box => hiển thị viền đỏ
                          color: controller.paymentIndex.value == index
                              ? redColor
                              : Colors.transparent,
                          width: 4,
                        )),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      /// Check box đặt bên trên phải cùng
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsImg[index],
                          width: double.infinity,
                          height: 120,
                          colorBlendMode: controller.paymentIndex.value == index
                              ? BlendMode.darken
                              : BlendMode.color,
                          color: controller.paymentIndex.value == index
                              ? Colors.black.withOpacity(0.4)
                              : Colors.transparent,
                          fit: BoxFit.cover,
                        ),

                        /// Kiểm tra check box => hiện thị check box
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                    activeColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    value: true,
                                    onChanged: (value) {}),
                              )
                            : Container(),

                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: paymentMethods[index]
                              .text
                              .white
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
