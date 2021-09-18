import 'package:flutter/foundation.dart';

class OrderContext with ChangeNotifier, DiagnosticableTreeMixin {
  List _orders = [];

  getOrders() {
    return _orders;
  }

  setOrders(List orders) {
    _orders = orders;
    notifyListeners();
  }

  updateItem({required oldElement, required updatedElement}) {
    List _updatedOrders = _orders.map((item) {
      if (item['id'] == updatedElement['id']) {
        return updatedElement;
      } else {
        return item;
      }
    }).toList();

    _orders = _updatedOrders;
    notifyListeners();
  }
}
