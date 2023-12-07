import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/home_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalPrice = 0.obs;

  ///text controller cho màn shipping details
  var addressController = TextEditingController();

  /// Tỉnh/Thành phố
  var cityController = TextEditingController();

  /// Quận/Huyện - State
  var districtController = TextEditingController();

  /// Phường - postal code
  var wardController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];

  var placingOrder = false.obs;

  calculate(data) {
    totalPrice.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalPrice.value =
          totalPrice.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);

    await getProductDetails();

    await firestore.collection(ordersCollection).doc().set({
      'order_code': "233981237",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_city': cityController.text,
      'order_by_district': districtController.text,
      'order_by_ward': wardController.text,
      'order_by_phone': phoneController.text,
      'shipping_method': "Giao hàng tận nhà",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
