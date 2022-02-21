import 'package:flutter/material.dart';
import 'package:waterpoj/model/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cart = [];

  List<Product> getcart() => _cart;

  addCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  increaseCartValue(int index) {
    Product _data = _cart[index];
    _data.quantity++;
    _cart[index] = _data;
    notifyListeners();
  }

  dicrimentCartValue(int index) {
    if (_cart[index].quantity > 1) {
      Product _data = _cart[index];
      _data.quantity--;
      _cart[index] = _data;
    } else {
      _cart.removeAt(index);
    }
    notifyListeners();
  }
}
