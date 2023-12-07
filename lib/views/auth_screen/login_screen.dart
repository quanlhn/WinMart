import 'package:firebase_tutorial/controller/auth_controller.dart';
import 'package:firebase_tutorial/views/auth_screen/signup_screen.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/consts/lists.dart';
import 'package:firebase_tutorial/views/home_screen/home.dart';
import 'package:firebase_tutorial/views/widgets_common/applogo_widget.dart';
import 'package:firebase_tutorial/views/widgets_common/bg_widget.dart';
import 'package:firebase_tutorial/views/widgets_common/custom_textfield.dart';
import 'package:firebase_tutorial/views/widgets_common/out_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // lấy controller authentication
    var controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Đăng nhập $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    // Tạo trường nhập text cho Email và Mật khẩu
                    customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.emailController,
                    ),
                    5.heightBox,
                    customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.passwordController,
                    ),

                    /// Button quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      // Tạo chữ "Quên mật khẩu"
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      ),
                    ),
                    5.heightBox,

                    /// Tạo button "Đăng nhập"
                    /// Tạo hiệu ứng loading
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: redColor,
                            title: login,
                            textColor: whiteColor,

                            /// Xử lý sự kiện "Đăng nhập"
                            onPress: () async {
                              /// set Loading = true để hiển thị hiệu ứng
                              controller.isLoading(true);

                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                if (value != null) {
                                  /// Thông báo đăng nhập thành công
                                  VxToast.show(context, msg: loginSuccess);

                                  /// chuyển màn Home (block turn back)
                                  Get.offAll(() => const Home());
                                } else {
                                  /// Đăng nhập thất bại:
                                  /// Set thành false để await onPress
                                  controller.isLoading(false);
                                  VxToast.show(context,
                                      msg: "Sai tài khoản hoặc mật khẩu");
                                }
                              });
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    // Tạo chữ "Hoặc đăng ký tài khoản mới"
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    // Tạo nút bấm "Đăng ký"
                    ourButton(
                        color: lightGolden,
                        title: signup,
                        textColor: redColor,
                        // Tạo chuyển hướng màn
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        }).box.width(context.screenWidth - 50).make(),
                    // Tạo chữ "Đăng nhập với"
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: lightGrey,
                            radius: 25,
                            child: Image.asset(
                              socialIconList[index],
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
