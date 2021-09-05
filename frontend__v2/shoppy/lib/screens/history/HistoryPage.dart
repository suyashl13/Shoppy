import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/contexts/Order.dart';
import 'package:shoppy/contexts/Product.dart';
import 'package:shoppy/helpers/BackendCartsHelper.dart';
import 'package:shoppy/helpers/BackendProductsHelper.dart';
import 'package:shoppy/screens/history/OrderDetailsPage.dart';
import 'package:shoppy/screens/static/ErrorPage.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 16),
        child: Consumer<Order>(
          builder: (context, order, child) {
            List orderList = order.getOrders();
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your\nOrders",
                      style: TextStyle(
                          fontFamily: 'Lucida',
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await BackendProductsHelper().getAvailableProducts(
                            (data) {
                          Provider.of<Product>(context, listen: false)
                              .setProducts(data);
                        }, (err) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ErrorPage()));
                        });

                        await BackendCartsHelper().getUserCarts((data) {
                          Provider.of<Order>(context, listen: false)
                              .setOrders(data);
                        }, (err) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ErrorPage()));
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.refresh_outlined),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                    child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (_, index) => ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsPage(orderDetails: orderList[index]))),
                    title: Text(
                        "${DateFormat.yMMMMd().format(DateTime.parse(orderList[index]['date_time_created'].toString().split('T')[0]))}"),
                    subtitle: Text("₹ ${orderList[index]['subtotal']}"),
                    trailing: Card(
                        color: Colors.blueGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "${orderList[index]['order_status']}",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}
