import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/contexts/Cart.dart';
import 'package:shoppy/helpers/BackendCartsHelper.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  Map optionalAddress = {};

  _setOptionalAddress() async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Set Custom Address"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        validator: (i) {
                          if (i!.length != 6) {
                            return "Please provide valid pincode.";
                          }
                        },
                        initialValue: optionalAddress['pin_code'] == null
                            ? null
                            : optionalAddress['pin_code'],
                        onSaved: (pinCode) {
                          setState(() {
                            optionalAddress['pin_code'] = pinCode;
                          });
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Pincode",
                          hintText: "Ex. 411046",
                        ),
                      ),
                      TextFormField(
                        validator: (i) {
                          if (i!.length != 10) {
                            return "Please provide valid phone no.";
                          }
                        },
                        keyboardType: TextInputType.phone,
                        onSaved: (phoneNo) {
                          setState(() {
                            optionalAddress['delivery_phone'] = phoneNo;
                          });
                        },
                        initialValue: optionalAddress['delivery_phone'] == null
                            ? null
                            : optionalAddress['delivery_phone'],
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: "Phone No.",
                          hintText: "Do not include (+91)",
                        ),
                      ),
                      TextFormField(
                        validator: (i) {
                          if (i!.length == 0) {
                            return "Cannot be empty";
                          }
                        },
                        onSaved: (shippingAddress) {
                          setState(() {
                            optionalAddress['shipping_address'] =
                                shippingAddress;
                          });
                        },
                        initialValue:
                            optionalAddress['shipping_address'] == null
                                ? null
                                : optionalAddress['shipping_address'],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Done"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 16),
        child: Consumer<Cart>(builder: (context, cart, child) {
          List cartItems = cart.getCartItems();
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your\nCart",
                    style: TextStyle(
                        fontFamily: 'Lucida',
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      cart.clearCart();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.delete_outlined),
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
                      itemCount: cartItems.length,
                      itemBuilder: (_, index) => ListTile(
                            trailing: GestureDetector(
                              onTap: () {
                                cart.removeCartItemAtIndex(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Discount : ${cartItems[index]['discount']} %\nTax : ${cartItems[index]['tax_percentage']} %"),
                                Card(
                                    color: Colors.blueGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        "₹ ${cartItems[index]['price'] * cartItems[index]['quantity']}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            ),
                            title: Text(
                              "${cartItems[index]['title']} (${cartItems[index]['quantity']})",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))),
              GestureDetector(
                onTap: () {
                  _setOptionalAddress();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      optionalAddress['pin_code'] == null
                          ? "Deliver to another address"
                          : "Delivering to custom address.",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                width: double.maxFinite,
                child: MaterialButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  child: isLoading
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  )),
                            ),
                            Text("Please Wait")
                          ],
                        )
                      : Text("Make Order (₹ ${cart.getCartSubTotal()})"),
                  onPressed: () async {
                    if (cartItems.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Empty cart!"),
                        duration: Duration(milliseconds: 700),
                      ));
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    BackendCartsHelper()
                        .makeOrderAtBackend(cartItems, optionalAddress, () {
                      // OnSuccess
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Order Successfull."),
                        duration: Duration(milliseconds: 700),
                        backgroundColor: Colors.green,
                      ));
                    }, (err) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(err.toString()),
                        backgroundColor: Colors.red,
                      ));
                    });
                    setState(() {
                      isLoading = false;
                      optionalAddress = {};
                    });
                  },
                ),
              ),
            ],
          );
        }));
  }
}
