import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/contexts/Cart.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  Map? productData;

  ProductPage({this.productData});

  @override
  _ProductPageState createState() => _ProductPageState(productData);
}

class _ProductPageState extends State<ProductPage> {
  Map? productData;
  bool _isAddedToCart = false;
  int _quantity = 0;

  _ProductPageState(this.productData);

  @override
  void initState() {
    super.initState();
    var currentCartItem = Provider.of<Cart>(context, listen: false).productIsAlreadyInCart(productData!['id']);
    if (currentCartItem != null) {
      setState(() {
        _isAddedToCart = true;
        _quantity = currentCartItem['quantity'];
      });
    }
  }

  void _editQuantity(bool isIncrement) {
    if (isIncrement) {
      if (_quantity < productData!['available_stock']) {
        setState(() {
          _quantity++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text("Maximum count exceeded."),backgroundColor: Colors.red,));
      }
    } else {
      if (_quantity > 0) {
        setState(() {
          _quantity--;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text("Cant decrement less than zero."),backgroundColor: Colors.red,));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: 450,
              flexibleSpace: FlexibleSpaceBar(
                background: Image(image: NetworkImage(productData!['product_image']),fit: BoxFit.cover,),
                title: Text(productData!['title']),
              ),
            ),],
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12,),
                  Text("   Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text("${productData!['description']}"),
                  ),
                  SizedBox(height: 12,),
                  Text("   Product Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    width: double.maxFinite,
                    child: Card(
                      elevation: 3,
                      color: Colors.green,
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Table(
                          textDirection: TextDirection.ltr,
                          // ignore: todo
                          //TODO: Complete this module.
                          children: [
                            TableRow(
                              children: [
                                Text("Product", textScaleFactor: 1.2, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
                                Text("${productData!['title']}", textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("MRP", textScaleFactor: 1.2, style: TextStyle(color: Colors.white),),
                                Text("Rs. ${productData!['price']}", textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.white),)
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("In Stock", textScaleFactor: 1.2, style: TextStyle(color: Colors.white),),
                                Text("${productData!['available_stock'] == 0 ? "No" : "Yes"}", textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.white),)
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("Tax", textScaleFactor: 1.2, style: TextStyle(color: Colors.white),),
                                Text("${productData!['tax_percentage']} %", textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.white),)
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("Discount", textScaleFactor: 1.2, style: TextStyle(color: Colors.white),),
                                Text("${productData!['discount']} %", textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.white),)
                              ]
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: 18,),
                  Text("   Add to cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: double.maxFinite,
                    child: Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 0,
                              color: Colors.lightGreen,
                              child: IconButton(
                                onPressed: (){
                                  _editQuantity(false);
                                },
                                icon: Icon(CupertinoIcons.minus),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: 12,),
                                Text("$_quantity", style: TextStyle(fontSize: 48),),
                                Text("Select quantity"),
                                SizedBox(height: 12,),
                              ],
                            ),
                            Card(
                              elevation: 0,
                              color: Colors.lightGreen,
                              child: IconButton(
                                onPressed: (){
                                  _editQuantity(true);
                                },
                                icon: Icon(CupertinoIcons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isAddedToCart ? MaterialButton(
                textColor: Colors.white,
                color: Colors.red,
                child: Text("Remove from cart."),
                onPressed: (){
                  Provider.of<Cart>(context, listen: false).removeItemFromCart(productData!['id']);
                  setState(() {
                    _isAddedToCart = false;
                    _quantity = 0;
                  });
                },) :
              MaterialButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text("Add to cart"),
                onPressed: (){
                  if (_quantity != 0) {
                    productData!['quantity'] = _quantity;
                    Provider.of<Cart>(context, listen: false).addItemToCart(productData!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 1000),
                      content: Text("Please select quantity.")));
                    return;
                  }
                  setState(() {
                    _isAddedToCart = true;
                  });
                },),
              Text("Rs. ${productData!['price']*_quantity} ($_quantity Units)")
            ],
          ),
        ),
      ),
    );
  }
}