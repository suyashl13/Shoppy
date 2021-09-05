import 'package:flutter/material.dart';
import 'package:shoppy/components/ProductCard.dart';

// ignore: must_be_immutable
class AllProductsPage extends StatelessWidget {
  List? allproducts = [];
  String? category;

  AllProductsPage({required List this.allproducts, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$category",
                style: TextStyle(fontFamily: 'Lucida', fontSize: 28)),
              SizedBox(height: 1.8,),
              Divider(),
              SizedBox(height: 4,),
              Expanded(child: GridView.count(
                crossAxisSpacing: 0,
                mainAxisSpacing: 12,
                crossAxisCount: 2,
                children: [
                  ...allproducts!.map((e) => ProductCard(productDetails: e,)).toList()
                ],
                ))
            ],
          ),
        ),
      ),
    );
  }
}