import 'dart:io';

import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/profile_controller.dart';
import 'package:firebase_tutorial/views/widgets_common/bg_widget.dart';
import 'package:firebase_tutorial/views/widgets_common/custom_textfield.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    /// Lấy dữ liệu từ ProfileController
    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Nếu data imageUrl RỖNG => Sử dụng ảnh profile default
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProfile3,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()

                  /// else if Nếu imageUrl CÓ dữ liệu
                  /// => Truyền dữ liệu từ data vào
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      /// else Nếu imageUrl Rỗng nhưng controller.profileImgPath KHÔNG rỗng
                      /// => Chức năng "Chọn ảnh mới từ File người dùng"
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              7.heightBox,

              /// Tạo button "Thay đổi"
              ourButton(
                color: redColor,
                onPress: () {
                  controller.changeImage(context);
                },
                textColor: whiteColor,
                title: "Thay đổi",
              ),
              const Divider(),
              15.heightBox,

              /// Tạo trường nhập text "Tên và Mật khẩu"
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false,
              ),
              10.heightBox,
              customTextField(
                controller: controller.oldPassController,
                hint: passwordHint,
                title: oldPass,
                isPass: true,
              ),
              10.heightBox,
              customTextField(
                controller: controller.newPassController,
                hint: passwordHint,
                title: newPass,
                isPass: true,
              ),
              20.heightBox,

              /// Tạo button "Lưu"
              /// Tạo hiệu ứng Loading
              controller.isLoading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                        color: redColor,

                        /// Xử lý xự kiện khi ấn "Lưu"
                        onPress: () async {
                          /// isLoading = true => Tạo hiệu ứng loading
                          controller.isLoading(true);

                          /// Nếu image không được chọn
                          if (controller.profileImgPath.value.isNotEmpty) {
                            await controller.uploadProfileImage();
                          } else {
                            controller.profileImageLink = data['imageUrl'];
                          }

                          /// Nếu mật khẩu cũ đúng với CSDL
                          if (data['password'] ==
                              controller.oldPassController.text) {
                            await controller.changeAuthPassword(
                              email: data['email'],
                              password: controller.oldPassController.text,
                              newPassword: controller.newPassController.text,
                            );

                            await controller.updateProfile(
                              imgUrl: controller.profileImageLink,
                              name: controller.nameController.text,
                              password: controller.newPassController.text,
                            );
                            VxToast.show(context,
                                msg: "Updated Profile Successfully");
                          } else {
                            VxToast.show(context, msg: "Mật khẩu cũ sai");
                            controller.isLoading(false);
                          }
                        },
                        textColor: whiteColor,
                        title: "Lưu",
                      ),
                    ),
            ],
          )
              .box
              .white
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .make(),
        ),
      ),
    );
  }
}
