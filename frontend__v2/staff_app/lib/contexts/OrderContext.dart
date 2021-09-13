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

  updateItem({required oldElement ,required updatedElement}) {
    int indexToUpdate = _orders.indexOf(oldElement);
    print(_orders[indexToUpdate]['payment_method']);
    _orders[indexToUpdate] = updatedElement;
    print(_orders[indexToUpdate]['payment_method']);
    notifyListeners();
  }

}
