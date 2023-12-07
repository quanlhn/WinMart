import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/consts/lists.dart';
import 'package:firebase_tutorial/controller/product_controller.dart';
import 'package:firebase_tutorial/views/chat_screen/chat_screen.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, this.title, this.data});

  @override
  Widget build(BuildContext context) {
    /// Tạo controller product
    var controller = Get.find<ProductController>();

    return WillPopScope(
      /// Khi bấm nút quay lại trên android cũng resetValues
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          /// Khi bấm trở về AppBar thì resetValue: số lượng và totalPrice
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),

          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),

          /// Tạo 2 icon trên AppBar
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: Icon(
                  Icons.favorite,
                  color: controller.isFav.value ? redColor : darkFontGrey,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tạo Cuộn màn hình ngang
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 400,

                          /// itemCount == index (itemCount = 2 => index = {0,1})
                          itemCount: data['p_imgs'].length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              data['p_imgs'][index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),
                      15.heightBox,

                      /// Phần "Tên" item
                      title!.text
                          .size(20)
                          .color(darkFontGrey)
                          .fontFamily(bold)
                          .make(),
                      10.heightBox,

                      // // Phần Điểm đánh giá
                      // VxRating(
                      //   onRatingUpdate: (value) {},
                      //   normalColor: textfieldGrey,
                      //   selectionColor: golden,
                      //   count: 5,
                      //   size: 25,
                      //   stepInt: true,
                      // ),
                      // 10.heightBox,

                      /// Phần "Giá niêm yết" và "Nhà cung cấp"
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    "Giá niêm yết: "
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .size(16)
                                        .make(),

                                    // Print tiền
                                    "${data['p_price']}"
                                        .numCurrencyWithLocale(locale: "vi")
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(18)
                                        .make(),
                                  ],
                                ),
                                const Divider(),
                                "Nhà cung cấp: ${data['p_seller']}"
                                    .text
                                    .color(darkFontGrey)
                                    .size(16)
                                    .fontFamily(semibold)
                                    .make(),
                                5.heightBox,
                              ],
                            ),
                          ),

                          /// Tạo Icon "chuyển màn Chat"
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.messenger_rounded,
                              color: darkFontGrey,
                            ),
                          ).onTap(() {
                            /// Xử lý sự kiện ở đây:
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [data['p_seller'], data['vendor_id']],
                            );
                          }),
                        ],
                      )
                          .box
                          .height(90)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),
                      20.heightBox,

                      /// Phần "Số lượng và Tổng giá tiền"
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Số lượng: "
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .size(16)
                                    .make(),
                              ),

                              /// Phần tăng - giảm số lượng
                              Obx(
                                () => Row(
                                  children: [
                                    /// Tạo nút "Giảm số lượng" (Dấu "-")
                                    IconButton(

                                        /// Xử lý sự kiện Giảm số lượng
                                        onPressed: () {
                                          controller.decreaseQuantity();
                                          controller.calculateTotalPrice(
                                              int.parse(data['p_price']));
                                        },
                                        icon: const Icon(Icons.remove)),

                                    /// Lấy dữ liệu quantity ra
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(darkFontGrey)
                                        .fontFamily(bold)
                                        .make(),

                                    /// Tạo nút "Tăng số lượng" (Dấu "+")
                                    IconButton(

                                        /// Xử lý sự kiện Tăng số lượng
                                        onPressed: () {
                                          controller.increaseQuantity(
                                              int.parse(data['p_quantity']));
                                          controller.calculateTotalPrice(
                                              int.parse(data['p_price']));
                                        },
                                        icon: const Icon(Icons.add)),
                                    10.heightBox,
                                    "(Số lượng còn lại: ${data['p_quantity']})"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .size(16)
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          const Divider(),

                          /// Phần "Tính toán Tổng giá tiền"
                          Obx(
                            () => Row(
                              children: [
                                SizedBox(
                                  width: 115,
                                  child: "Tổng giá tiền: "
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .size(16)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrencyWithLocale(locale: "vi")
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ),
                          10.heightBox,
                        ],
                      ).box.white.shadowSm.make(),
                      20.heightBox,

                      // Phần mô tả Description
                      "Mô tả"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),
                      10.heightBox,

                      // Phần Buttons
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          // Chiều dài của List "chi tiết item Buttons"
                          itemDetailButtonsList.length,
                          (index) => ListTile(
                            // index từ 0 -> chiều dài của list
                            title: itemDetailButtonsList[index]
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                      20.heightBox,

                      // Phần "Sản phẩm tương tự"
                      productsYouMayLike.text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            6,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  imgP1,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                10.heightBox,
                                // Tạo chữ Laptop
                                "Laptop 4GB/64GB"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                // Tạo chữ 600 đô
                                "\$600"
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make()
                              ],
                            )
                                .box
                                .white
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .padding(const EdgeInsets.all(8))
                                .make(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Phần "Thêm vào giỏ hàng"
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: redColor,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                        context: context,
                        vendorId: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellerName: data['p_seller'],
                        title: data['p_name'],
                        totalPrice: controller.totalPrice.value,
                      );
                      VxToast.show(context, msg: "Đã thêm vào giỏ hàng!");
                    } else {
                      VxToast.show(context, msg: "Số lượng phải lớn hơn 0!");
                    }
                  },
                  textColor: whiteColor,
                  title: "THÊM VÀO GIỎ"),
            ),
          ],
        ),
      ),
    );
  }
}
