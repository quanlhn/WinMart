import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/category_screen/item_details.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: title!.text.color(darkFontGrey).fontFamily(semibold).make(),
        ),
        body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "Không tìm thấy sản phẩm".text.makeCentered();
            } else {
              /// Lấy data
              var data = snapshot.data!.docs;

              /// filter data logic chức năng "Tìm Kiếm"
              var filtered = data
                  .where((element) => element['p_name']
                      .toString()
                      .toLowerCase()
                      .contains(title!.toLowerCase()))
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 6,

                    /// Chiều dài grind
                    mainAxisExtent: 350,
                  ),
                  children: filtered
                      .mapIndexed(
                        (currentValue, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// create Image product
                            Image.network(
                              filtered[index]['p_imgs'][0],
                              height: 200,
                              // width: 200,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            10.heightBox,
                            // create name product
                            "${filtered[index]['p_name']}"
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            10.heightBox,
                            // Tạo giá tiền tạm thời
                            "${filtered[index]['p_price']}"
                                .numCurrencyWithLocale(locale: "vi")
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                          ],
                        )
                            .box
                            .white
                            .outerShadowMd
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          Get.to(
                            () => ItemDetails(
                              title: "${filtered[index]['p_name']}",
                              data: filtered[index],
                            ),
                          );
                        }),
                      )
                      .toList(),
                ),
              );
            }
          },
        ));
  }
}
