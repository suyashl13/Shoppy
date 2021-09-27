import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:staff_app/contexts/OrderContext.dart';
import 'package:staff_app/helpers/BackendOrderHelper.dart';

// ignore: must_be_immutable
class SheetComponent extends StatefulWidget {
  late Map orderDetails;
  SheetComponent(this.orderDetails);

  @override
  _SheetComponentState createState() => _SheetComponentState(orderDetails);
}

class _SheetComponentState extends State<SheetComponent> {
  late Map orderDetails;
  _SheetComponentState(orderDetails) {
    this.orderDetails = orderDetails;

  }

  bool isLoading = false;
  String modeOfPayment = "COD";

  showAlertDialog(context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Alert"),
              content: Text("Once marked as delivered cannot be undone."),
              actions: [
                TextButton(onPressed: () async {
                    await BackendOrderHelper().updateCartAtBackend(cartId: orderDetails['id'], cartUpdate: {
                      'payment_method': modeOfPayment,
                      'is_delivered': 'true'},
                      onSuccess: (data) {
                        Provider.of<OrderContext>(context, listen: false).updateItem(oldElement: orderDetails, updatedElement: data);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }, onError: (error) { 
                        ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Opps! Something went wrong")));
                      }
                    );
                }, child: Text("Mark as Delivered")),
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select mode of payment"),
              DropdownButton<String>(
                value: modeOfPayment,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    child: Text("COD"),
                    value: "COD",
                  ),
                  DropdownMenuItem(
                    child: Text("UPI"),
                    value: "UPI",
                  ),
                ],
                onChanged: (String? val) {
                  setState(() {
                    modeOfPayment = val!;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          modeOfPayment == 'COD'
              ? Center(
                  child: SizedBox(
                    height: 240,
                    width: 240,
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          "Cant show QR\non COD payment.",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      QrImage(
                          size: 200,
                          data:
                              "upi://pay?pa=suyash.lawand@okaxis&pn=Suyash%20Lawand&am=${orderDetails['subtotal']}&cu=INR&aid=uGICAgICgy_GPDw"),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "UPI QR CODE",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 28,
          ),
          Container(
              width: double.maxFinite,
              child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                  onPressed: () async {
                    showAlertDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Mark as Delivered\n(Rs. ${orderDetails['subtotal']} - $modeOfPayment)",
                      textAlign: TextAlign.center,
                    ),
                  )))
        ],
      ),
    );
  }
}
