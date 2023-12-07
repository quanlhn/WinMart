import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/views/orders_screen/components/order_place_details.dart';
import 'package:firebase_tutorial/views/orders_screen/components/order_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Chi tiết đơn hàng"
            .text
            .fontFamily(bold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// Thanh Trạng Thái đơn hàng
              orderStatus(
                newColor: redColor,
                icon: Icons.done,
                title: "Đã đặt hàng ",
                showDone: data['order_placed'],
              ),
              orderStatus(
                newColor: Colors.blue,
                icon: Icons.thumb_up,
                title: "Đang xác nhận ",
                showDone: data['order_confirmed'],
              ),
              orderStatus(
                newColor: const Color.fromARGB(255, 224, 202, 9),
                icon: Icons.delivery_dining,
                title: "Đang giao hàng ",
                showDone: data['order_on_delivery'],
              ),
              orderStatus(
                newColor: Colors.purple,
                icon: Icons.assignment_turned_in_rounded,
                title: "Đã nhận hàng ",
                showDone: data['order_delivered'],
              ),
              const Divider(),
              10.heightBox,

              /// Phần thông tin chi tiết đơn hàng
              Column(
                children: [
                  orderPlaceDetails(
                    detail1: data['order_code'],
                    detail2: data['shipping_method'],
                    title1: "Mã đơn hàng",
                    title2: "Phương thức giao hàng",
                  ),
                  orderPlaceDetails(
                    detail1: intl.DateFormat()
                        .add_yMd()
                        .format((data['order_date'].toDate())),
                    detail2: data['payment_method'],
                    title1: "Ngày đặt hàng",
                    title2: "Phương thức thanh toán",
                  ),
                  orderPlaceDetails(
                    detail1: "Chưa thanh toán",
                    detail2: "Đã đặt hàng",
                    title1: "Trạng thái thanh toán",
                    title2: "Trạng thái giao hàng",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: .0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Địa chỉ giao hàng"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "Họ tên: ${data['order_by_name']}".text.make(),
                            "Email: ${data['order_by_email']}".text.make(),
                            "Địa chỉ: ${data['order_by_address']}".text.make(),
                            "Tỉnh/Thành phố: ${data['order_by_city']}"
                                .text
                                .make(),
                            "Quận/Huyện: ${data['order_by_district']}"
                                .text
                                .make(),
                            "Phường/Xã: ${data['order_by_ward']}".text.make(),
                            "Số điện thoại: ${data['order_by_phone']}"
                                .text
                                .make(),
                            5.heightBox,
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              "Giá tiền sản phẩm"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),
                              "${data['total_amount']}"
                                  .numCurrencyWithLocale(locale: "vi")
                                  .text
                                  .color(redColor)
                                  .make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),

              15.heightBox,

              ///
              "Sản Phẩm Đã Đặt"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,

              ///
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  data['orders'].length,
                  (index) {
                    return orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: "${data['orders'][index]['tprice']}"
                          .numCurrencyWithLocale(locale: "vi"),
                      detail1: "x${data['orders'][index]['qty']}",
                      detail2: "Có thể đổi trả",
                    );
                  },
                ).toList(),
              ).box.outerShadowMd.white.make(),
              20.heightBox,

              ///
              // Row(
              //   children: [
              //     "GIÁ TIỀN SẢN PHẨM"
              //         .text
              //         .size(16)
              //         .fontFamily(semibold)
              //         .color(darkFontGrey)
              //         .make(),
              //     "GIÁ TIỀN VẬN CHUYỂN"
              //         .text
              //         .size(16)
              //         .fontFamily(semibold)
              //         .color(darkFontGrey)
              //         .make(),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
