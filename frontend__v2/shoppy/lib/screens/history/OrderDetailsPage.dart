import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:shoppy/components/BottomInfoSheet.dart';
import 'package:shoppy/screens/history/OrderDialogHelper.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatelessWidget {
  Map orderDetails;
  OrderDetailsPage({required this.orderDetails});

  _getOrderDetails() {
    print(this.orderDetails['courier_details']);
    Map orderDetails = {
      'Date Ordered':
          "${DateFormat.yMMMMd().format(DateTime.parse(this.orderDetails['date_time_created'].toString().split('T')[0]))}",
      'Discounted Price': "₹ " + this.orderDetails['discount_price'].toString(),
      'Payment Method': this.orderDetails['payment_method'] == null
          ? 'Pending'
          : this.orderDetails['payment_method'],
      'Order Status': this.orderDetails['order_status'],
      'Address': this.orderDetails['shipping_address']
    };
    if (this.orderDetails['courier_details'] != null) {
      orderDetails['Courier Name'] = this.orderDetails['courier_details']['courier_name'];
      orderDetails['Courier Tracking ID'] = this.orderDetails['courier_details']['courier_tracking_id'];
    }
    return orderDetails;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (scaffoldContext) {
        return SafeArea(
            child: Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "#${orderDetails['id']}",
                        style: TextStyle(
                            fontFamily: 'Lucida',
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      showDialog(context: context, 
                      builder: (context) => AlertDialog(
                        title: Text("Options"),
                        content: OrderDialogHelper(cartId: orderDetails['id'], isCanceled: orderDetails['is_canceled'], isVerified: orderDetails['is_verified'],),
                      ),);
                    },
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
              Expanded(
                  child: ListView.builder(
                      itemCount: orderDetails['cart_items'].length,
                      itemBuilder: (_, index) {
                        Map cartItem = orderDetails['cart_items'][index];
                        return ListTile(
                          trailing: Card(
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  "₹ ${cartItem['amount']}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                          title: Text(
                            "${cartItem['product']['title']} (${cartItem['quantity']})",
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                              "Discount : ${cartItem['product']['discount']} %\n" +
                                  "Tax : ${cartItem['product']['discount']} %"),
                        );
                      })),
              Container(
                width: double.maxFinite,
                child: MaterialButton(
                    textColor: Colors.blue,
                    child: Text("See Details"),
                    onPressed: () {
                      Scaffold.of(scaffoldContext)
                          .showBottomSheet((context) => BottomInfoSheet(
                                _getOrderDetails(),
                              ));
                    }),
              ),
            ],
          ),
        ));
      }),
    );
  }
}
