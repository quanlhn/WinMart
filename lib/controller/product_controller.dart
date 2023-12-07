import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/models/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var totalPrice = 0.obs;

  var subCate = [];

  var isFav = false.obs;

  /// Lấy ra dữ liệu "Danh mục con"
  getSubCategories(title) async {
    subCate.clear();
    var data = await rootBundle.loadString("lib/json/category_models.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subCate.add(e);
    }
  }

  /// Tăng số lượng để mua
  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  /// Giảm số lượng để mua
  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  /// Tính số lượng sau khi Tăng - Giảm
  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  /// Thêm vào Giỏ hàng
  addToCart({title, img, sellerName, qty, totalPrice, context, vendorId}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellerName,
      'qty': qty,
      'vendor_id': vendorId,
      'tprice': totalPrice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  /// reset lại value về 0
  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
  }

  /// Thêm vào danh sách yêu thích
  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid]),
    }, SetOptions(merge: true));

    isFav(true);
    VxToast.show(context, msg: "Đã thêm vào danh sách yêu thích!");
  }

  /// Xóa khỏi danh sách yêu thích
  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid]),
    }, SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: "Đã xóa khỏi danh sách yêu thích!");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
