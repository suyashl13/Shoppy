import 'package:flutter/foundation.dart';

class Order with ChangeNotifier, DiagnosticableTreeMixin {
  var _orders = [];

  setOrders(orders) {
    _orders = orders;
    notifyListeners();
  }

  getOrders() {
    return _orders;
  }
}