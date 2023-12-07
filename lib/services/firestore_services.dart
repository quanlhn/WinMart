import 'package:firebase_tutorial/consts/consts.dart';

class FirestoreServices {
  // Lấy dữ liệu user
  static getUSer(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // Lấy dữ liệu products theo category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  // Lấy dữ liệu Danh mục phu SubCategory
  static getSubCategoryProduct(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  // Lấy dữ liệu cart theo uid
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  /// Xóa document trong màn Cart
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  /// Lấy tất cả Tin nhắn trong bảng chats
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  /// Lấy tất cả đơn hàng trong bảng orders
  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  /// Lấy tất cả Yêu thích từ id người dùng:
  /// select * from products where p_wishlist contain id
  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  ///Lấy tất cả tin nhắn trong bảng chats
  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  /// Lấy số count trong màn profile
  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      })
    ]);
    return res;
  }

  /// Lấy tất cả bảng products
  static allProducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  /// Lấy Sản phẩm phổ biến featured products
  static getFeaturedProduct() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  /// Tìm kiếm products
  static searchProducts(title) {
    return firestore
        .collection(productsCollection)
        // .where('p_name', isLessThanOrEqualTo: title)
        .get();
  }
}
