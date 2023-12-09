import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/consts/lists.dart';
import 'package:firebase_tutorial/controller/auth_controller.dart';
import 'package:firebase_tutorial/controller/profile_controller.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/auth_screen/login_screen.dart';
import 'package:firebase_tutorial/views/chat_screen/messaging_screen.dart';
import 'package:firebase_tutorial/views/orders_screen/orders_screen.dart';
import 'package:firebase_tutorial/views/profile_screen/components/details_card.dart';
import 'package:firebase_tutorial/views/profile_screen/edit_profile_screen.dart';
import 'package:firebase_tutorial/views/widgets_common/bg_widget.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:firebase_tutorial/views/wishlist_screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          // Lấy dữ liệu người dùng từ Firebase theo uid (id người dùng)
          stream: FirestoreServices.getUSer(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Kiểm tra nếu không có dữ liệu => loading liên tục
            // Đôi khi Firebase up dữ liệu chậm thì sẽ vào trường hợp này
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else {
              // Nếu có dữ liệu => Set vào var data để sử dụng
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    // Tạo button "chỉnh sửa ảnh đại diện"
                    Padding(
                      // padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ).onTap(() {
                        /// Set lại name và password vào controller
                        controller.nameController.text = data['name'];

                        /// truyền data vào Màn Chỉnh sửa Profile
                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),

                    /// Tạo Row cho phần chi tiết tài khoản
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              /// Tạo ảnh profile
                              /// Nếu trường imageUrl của user rỗng => profile image default
                              data['imageUrl'] == ''
                                  ? Image.asset(
                                      imgProfile3,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.network(
                                      data['imageUrl'],
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                              10.heightBox,

                              // Tạo Tên user và Email user
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "${data['name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .white
                                        .make(),
                                    5.heightBox,
                                    "${data['email']}".text.white.make(),
                                  ],
                                ),
                              ),

                              /// Tạo button đăng xuất
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: lightGrey,
                                  ),
                                ),
                                // xử lý sự kiện button Đăng xuất
                                onPressed: () async {
                                  await Get.put(
                                      AuthController().signoutMethod(context));
                                  // chuyển màn Login (không quay lại được)
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: logout.text
                                    .fontFamily(semibold)
                                    .color(redColor)
                                    .make(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).box.roundedSM.make(),
                    10.heightBox,

                    /// Tạo Column thống kê giỏ hàng
                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    detailsCard(
                                      count: countData[0].toString(),
                                      title: "Giỏ hàng",
                                      width: context.screenWidth / 3.2,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    detailsCard(
                                      count: countData[1].toString(),
                                      title: "Yêu thích",
                                      width: context.screenWidth / 3.2,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    detailsCard(
                                      count: countData[2].toString(),
                                      title: "Đơn hàng",
                                      width: context.screenWidth / 3.2,
                                    ),
                                  ],
                                )
                                    .box
                                    .rounded
                                    .margin(const EdgeInsets.all(1))
                                    .make()
                                    .box
                                    .color(redColor)
                                    .make(),
                              ],
                            );
                          }
                        }),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(
                    //         count: data['cart_count'],
                    //         title: "Giỏ hàng",
                    //         width: context.screenWidth / 3.2),
                    //     detailsCard(
                    //         count: data['wishlist_count'],
                    //         title: "Yêu thích",
                    //         width: context.screenWidth / 3.2),
                    //     detailsCard(
                    //         count: data['order_count'],
                    //         title: "Đơn hàng",
                    //         width: context.screenWidth / 3.2),
                    //   ],
                    // )
                    //     .box
                    //     .rounded
                    //     .margin(const EdgeInsets.all(1))
                    //     .make()
                    //     .box
                    //     .color(redColor)
                    //     .make(),

                    // Button option tài khoản
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrdersScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                Get.to(() => const MessagesScreen());
                                break;
                              default:
                            }
                          },
                          leading: Image.asset(
                            profileButtonsIcon[index],
                            width: 22,
                          ),
                          title: profileButtonsList[index]
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                        );
                      },
                    )
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
