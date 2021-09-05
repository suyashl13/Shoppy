import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:shoppy/components/CategoryCard.dart';
import 'package:shoppy/contexts/Order.dart';
import 'package:shoppy/contexts/Product.dart';
import 'package:shoppy/helpers/BackendCartsHelper.dart';
import 'package:shoppy/helpers/BackendProductsHelper.dart';
import 'package:shoppy/screens/history/OrderDetailsPage.dart';
import 'package:shoppy/screens/home/HomeDialogHelper.dart';
import 'package:shoppy/screens/static/ErrorPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences _preferences;
  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      isInitialized = true;
    });
  }

  _showHomeDialog() async {
    return await showDialog(
        context: context,
        builder: (context) => Dialog(child: HomeDialogHelper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      isInitialized ? "${_preferences.getString('name')}" : " ",
                      style: TextStyle(
                          fontFamily: 'Lucida',
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: _showHomeDialog,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.menu),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Divider(),
            Text("Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 114,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...Provider.of<Product>(context, listen: false)
                      .getProducts()
                      .map(
                        (e) => CategoryCard(
                          category: e,
                        ),
                      )
                      .toList()
                ],
              ),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Active Orders",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.black54,
                  ),
                  onTap: () async {
                    await BackendProductsHelper().getAvailableProducts((data) {
                      Provider.of<Product>(context, listen: false)
                          .setProducts(data);
                    }, (err) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ErrorPage()));
                    });

                    await BackendCartsHelper().getUserCarts((data) {
                      Provider.of<Order>(context, listen: false)
                          .setOrders(data);
                    }, (err) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ErrorPage()));
                    });
                  },
                )
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...Provider.of<Order>(context)
                        .getOrders()
                        .map((e) => e['order_status'] != 'Assigned'
                            ? SizedBox()
                            : ListTile(
                                leading: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.green,
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            OrderDetailsPage(orderDetails: e))),
                                trailing: Card(
                                    color: Colors.blueGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        e['order_status'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                subtitle: Text("₹ ${e['subtotal']}"),
                                title: Text(
                                    "${DateFormat.yMMMMd().format(DateTime.parse(e['date_time_created'].toString().split('T')[0]))}"),
                              ))
                        .toList()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}