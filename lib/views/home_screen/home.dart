import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/home_controller.dart';
import 'package:firebase_tutorial/views/cart_screen/cart_screen.dart';
import 'package:firebase_tutorial/views/category_screen/category_screen.dart';
import 'package:firebase_tutorial/views/home_screen/home_screen.dart';
import 'package:firebase_tutorial/views/profile_screen/profile_screen.dart';
import 'package:firebase_tutorial/views/widgets_common/exit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo home controller
    var controller = Get.put(HomeController());

    // Truyền giá trị cho thanh công cụ
    var navBarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(icHome, width: 26), label: home),
      BottomNavigationBarItem(
          icon: Image.asset(icCategories, width: 26), label: categories),
      BottomNavigationBarItem(
          icon: Image.asset(icCart, width: 26), label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(icProfile, width: 26), label: account),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value),
              ),
            ),
          ],
        ),
        // Tạo UI cho thanh công cụ
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navBarItem,
            // Nhập sự kiện Tap vào index thanh công cụ
            onTap: (newValue) {
              controller.currentNavIndex.value = newValue;
            },
          ),
        ),
      ),
    );
  }
}
