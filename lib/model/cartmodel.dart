import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  List<Map<String, dynamic>> _selectedProducts = [];

  int get cartCount => _selectedProducts.length; // Getter for cart count

  List<Map<String, dynamic>> get selectedProducts => _selectedProducts;

  void addToCart(Map<String, dynamic> product) {
    _selectedProducts.add(product);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _selectedProducts.remove(product);
    notifyListeners();
  }
}

