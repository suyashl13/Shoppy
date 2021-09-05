import 'package:flutter/material.dart';
import 'package:shoppy/screens/shop/AllProductsPage.dart';

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  Map category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductsPage(allproducts: category['products'], category: category['name'],))),
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(category['display_url']),)
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
                Text(" " + category['products'].length.toString() + ' ', style: TextStyle(fontSize: 44, fontFamily: 'Poppins', color: Colors.white),),
                Text(category['products'].length == 1 || category['products'].length == 0 ? "Product" : "Products", 
                style: TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.white),),  
              ],),
              Text(" " + category['name'] + ' ', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            ],
          ),
        )
      ),
    );
  }
}