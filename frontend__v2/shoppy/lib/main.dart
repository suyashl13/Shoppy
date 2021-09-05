// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/FirebaseAuthWrapper.dart';
import 'package:shoppy/contexts/Cart.dart';
import 'package:shoppy/contexts/Order.dart';
import 'package:shoppy/contexts/Product.dart';
import 'package:shoppy/screens/ContainerPage.dart';
import 'package:shoppy/screens/history/HistoryPage.dart';
import 'package:shoppy/screens/home/HomePage.dart';
import 'package:shoppy/screens/shop/ProductPage.dart';
import 'package:shoppy/screens/shop/ShopPage.dart';
import 'package:shoppy/screens/static/UpdateProfilePage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Order()),
      ChangeNotifierProvider(create: (_) => Product()),
      ChangeNotifierProvider(create: (_) => Cart()),

      Provider(create: (_) => HomePage()),
      Provider(create: (_) => ContainerPage()),
      Provider(create: (_) => ShopPage()),
      Provider(create: (_) => ProductPage()),
      Provider(create: (_) => HistoryPage())
    ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoppy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins'
      ),
      home: FirebasebaseAuthWrapper(),
    );
  }
}