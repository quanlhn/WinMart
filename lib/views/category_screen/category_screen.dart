import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/consts/lists.dart';
import 'package:firebase_tutorial/controller/product_controller.dart';
import 'package:firebase_tutorial/views/category_screen/category_details.dart';
import 'package:firebase_tutorial/views/widgets_common/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Container(
          color: redColor,
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,

                /// Chiều dài mỗi Grid
                mainAxisExtent: 185),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    categoriesImages[index],
                    height: 120,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  15.heightBox,
                  categoriesList[index]
                      .text
                      .color(darkFontGrey)
                      .fontFamily(bold)
                      .size(15)
                      .align(TextAlign.center)
                      .make(),
                ],
              )
                  .box
                  .white
                  .rounded
                  .clip(Clip.antiAlias)
                  .outerShadowSm
                  .make()
                  .onTap(() {
                controller.getSubCategories(categoriesList[index]);
                Get.to(() => CategoryDetails(title: categoriesList[index]));
              });
            },
          ),
        ),
      ),
    );
  }
}
