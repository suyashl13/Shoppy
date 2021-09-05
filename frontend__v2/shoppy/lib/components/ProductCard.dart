import 'package:flutter/material.dart';
import 'package:shoppy/screens/shop/ProductPage.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  Map? productDetails;

  ProductCard({@required this.productDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(productData: productDetails,))),
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(productDetails!['product_image']),)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              Column(children: [
                
              ],),
              Text(" " + productDetails!['title'] + ' ', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            ],
          ),
        )
      ),
    );
  }
}