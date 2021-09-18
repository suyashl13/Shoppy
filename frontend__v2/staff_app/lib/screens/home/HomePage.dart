import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_app/contexts/OrderContext.dart';
import 'package:staff_app/helpers/BackendAuthHelper.dart';
import 'package:staff_app/helpers/BackendOrderHelper.dart';
import 'package:staff_app/screens/auth/AuthenticationPage.dart';
import 'package:staff_app/screens/orders/OrderSlugPage.dart';
import 'package:staff_app/screens/static/ErrorPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool isDeactivated = false;
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    _preferences = await SharedPreferences.getInstance();
    await BackendOrderHelper().getDeliverableCartsFromBackend(
        onSuccess: (data) {
      setState(() {
        Provider.of<OrderContext>(context, listen: false).setOrders(data);
      });
    }, onError: (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to fetch data."),
        backgroundColor: Colors.red,
      ));
      if (err == 'Staff Deactivated.') {
        setState(() {
          isDeactivated = true;
        });
      } else if (err == 'Unauthorized') {
        _signOut();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Only staff can use this app."),
          backgroundColor: Colors.red,
        ));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ErrorPage()));
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  _signOut() async {
    BackendAuthHelper().signOutAtBackend(onSuccess: (res) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AuthenticationPage()));
    }, onError: (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to logout, please try again later."),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hi,"),
                                  Text(
                                    "${_preferences.get('name')}",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await _signOut();
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.green,
                                  ))
                            ],
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
                      child: isDeactivated
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(4)),
                              padding: EdgeInsets.all(12),
                              child: Text(
                                  "Looks like your account is deactivated by higher authorities."),
                            )
                          : Consumer<OrderContext>(
                              builder: (context, orderContext, child) {
                                final List pendingOrders = orderContext.getOrders();
                                return ListView.builder(
                                  itemCount: pendingOrders.length,
                                  itemBuilder: (context, index) => ListTile(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => OrderSlugPage(
                                                pendingOrders[index]))),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "#${pendingOrders[index]['id']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                        "${pendingOrders[index]['user']['name']} (${DateFormat.yMMMMd().format(DateTime.parse(pendingOrders[index]['date_time_created']))})"),
                                    subtitle: Text(
                                        "₹ ${pendingOrders[index]['subtotal']} " +
                                            "(${pendingOrders[index]['cart_items'].length} Items)"),
                                    trailing: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
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
                                );
                              },
                            ),
                    ))
                  ],
                ),
        ),
      ),
    );
  }
}
