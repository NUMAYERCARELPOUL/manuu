import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  List<Map<String, dynamic>> cartItems = [];

  int get cartCount => cartItems.length;

  void addToCart(Map<String, dynamic> product) {
    cartItems.add(product);
    notifyListeners();
  }
}

