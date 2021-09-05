import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier, DiagnosticableTreeMixin {
  List _cartItems = [];

  setCartItems(List cartItems) {
    _cartItems = cartItems;
    notifyListeners();
  }

  addItemToCart(Map item) {
    _cartItems.add({...item});
    notifyListeners();
  }

  removeItemFromCart(int id) {
    _cartItems.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }

  getCartItems() {
    return this._cartItems;
  }

  Map? productIsAlreadyInCart(int id) {
    for (var cartItem in _cartItems) {
      if (cartItem['id'] == id) {
        return cartItem;
      }
    }
    return null;
  }

  double getCartSubTotal() {
    double subTotal = 0.0;
    for (var cartItem in _cartItems) {
      subTotal += cartItem['price'] * cartItem['quantity'];
    }
    return subTotal;
  }

  removeCartItemAtIndex(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  clearCart() {
    _cartItems = [];
    notifyListeners();
  }

}