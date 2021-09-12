import 'package:flutter/material.dart';
import 'package:staff_app/screens/orders/BottomSheetComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSlugPage extends StatelessWidget {
  final Map orderDetails;
  OrderSlugPage(this.orderDetails) {
    print(orderDetails);
  }

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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Column(
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
                      SizedBox(height: 12),
                      Text(" User", style: TextStyle(fontSize: 24)),
                    ],
                  ),
                )
              ],
            ),
            DraggableScrollableSheet(
              minChildSize: 0.08,
              initialChildSize: 0.08,
              maxChildSize: 0.8,
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.keyboard_arrow_up),
                      BottomSheetComponent(),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      );
}
