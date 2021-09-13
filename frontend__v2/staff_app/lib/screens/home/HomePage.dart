import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staff_app/helpers/BackendOrderHelper.dart';
import 'package:staff_app/screens/orders/OrderSlugPage.dart';
import 'package:staff_app/screens/static/ErrorPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List pendingOrders = [];

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    await BackendOrderHelper().getDeliverableCartsFromBackend(
        onSuccess: (data) {
      setState(() {
        pendingOrders = data;
      });
    }, onError: (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to fetch data."),
        backgroundColor: Colors.red,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ErrorPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("#staff_id"),
                    Text(
                      "Bill Gates",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  await _setPage();
                },
                child: ListView.builder(
                  itemCount: pendingOrders.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                OrderSlugPage(pendingOrders[index]))),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#${pendingOrders[index]['id']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                        "${pendingOrders[index]['user']['name']} (${DateFormat.yMMMMd().format(DateTime.parse(pendingOrders[index]['date_time_created']))})"),
                    subtitle: Text("₹ ${pendingOrders[index]['subtotal']} " +
                        "(${pendingOrders[index]['cart_items'].length} Items)"),
                    trailing: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.green,
                      child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
