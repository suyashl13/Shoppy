import 'package:flutter/foundation.dart';

class OrderContext with ChangeNotifier, DiagnosticableTreeMixin {
  List _orders = [];

  getOrders() => _orders;

  setOrders(List orders) {
    _orders = orders;
    notifyListeners();
  }

}
