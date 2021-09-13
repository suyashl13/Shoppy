import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CartItemList extends StatelessWidget {
  List cartItems;

  CartItemList(this.cartItems);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
        Map productDetails = cartItems[index]['product'];
        return ListTile(
          leading: CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage(productDetails['product_image']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(productDetails['title']),
          subtitle: Text("Quantity : " +
              cartItems[index]['quantity'].toString() +
              " Unit(s)"),
          trailing: Card(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  "Rs. ${productDetails['price'] * cartItems[index]['quantity']}",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        );
      });
  }
}
