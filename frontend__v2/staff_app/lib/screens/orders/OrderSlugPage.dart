import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staff_app/components/CartItemList.dart';
import 'package:staff_app/components/SheetComponent.dart';
import 'package:staff_app/components/UserDetailsComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSlugPage extends StatelessWidget {
  final Map orderDetails;

  OrderSlugPage(this.orderDetails);

  _callCustomer(context) {
    try {
      launch('tel:+${orderDetails['user']['phone']}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to call ${orderDetails['user']['phone']}."),
        backgroundColor: Colors.red,
      ));
    }
  }

  Map getUserDetailData() {
    return {
      "Name": orderDetails['user']['name'],
      "Email": orderDetails['user']['email'],
      "Customer Phone": orderDetails['user']['phone'],
      "Delivery Address": orderDetails['shipping_address'],
      "Delivery Pincode": orderDetails['pin_code'],
      "Delivery Phone no.": orderDetails['delivery_phone'],
      'Order Status': orderDetails['order_status'],
      "Subtotal": "Rs. " + orderDetails['subtotal'].toString(),
      "Date Ordered": DateFormat.yMMMMd()
          .format(DateTime.parse(orderDetails['date_time_created']))
    };
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              height: double.maxFinite,
              child: Column(
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
                            Text("#${orderDetails['id']}",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () => _callCustomer(context),
                                icon: Icon(Icons.phone, color: Colors.green))
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 4),
                        Text(" Order Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        UserDetailsComponent(getUserDetailData()),
                        SizedBox(height: 16),
                        Text(" Cart Items",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.1,
                          child: CartItemList(orderDetails['cart_items']),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            orderDetails['order_status'] == 'Pending Verification'
                ? Positioned(
                    bottom: 12,
                    left: MediaQuery.of(context).size.width / 8,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.black,
                      width: double.maxFinite,
                      child: Text("Call Customer and ask to verify the order."),
                    ),
                  )
                : DraggableScrollableSheet(
                    minChildSize: 0.08,
                    initialChildSize: 0.08,
                    maxChildSize: 0.64,
                    builder: (context, scrollController) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 4.0)
                          ]),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.keyboard_arrow_up),
                                  Text("Checkout")
                                ],
                              ),
                            ),
                            Divider(),
                            SheetComponent(orderDetails)
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        )),
      );
}
