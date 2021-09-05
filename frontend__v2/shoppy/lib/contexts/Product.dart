import 'package:flutter/foundation.dart';

class Product with ChangeNotifier, DiagnosticableTreeMixin {
  var _products = [];

  setProducts(products) {
    _products = products;
    notifyListeners();
  }

  getProducts() {
    return _products;
  }

}