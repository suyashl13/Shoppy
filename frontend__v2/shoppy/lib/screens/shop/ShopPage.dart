import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/components/CategoryCard.dart';
import 'package:shoppy/contexts/Product.dart';

class ShopPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome to\nShop !",
            style: TextStyle(fontFamily: 'Lucida', fontSize: 28)),
        SizedBox(height: 6,),
        Divider(),
        SizedBox(height: 6,),
        Expanded(
          child: GridView.count(
            crossAxisSpacing: 0,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            children: [
              ...Provider.of<Product>(context).getProducts().map((e) => CategoryCard(category: e,)).toList()
            ],
            ),)
        ]  
      )
    );
  }
}