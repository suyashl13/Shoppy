import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staff_app/AuthWrapper.dart';
import 'package:staff_app/components/SheetComponent.dart';
import 'package:staff_app/contexts/OrderContext.dart';
import 'package:staff_app/contexts/ProfileContext.dart';
import 'package:staff_app/screens/home/HomePage.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OrderContext()),
      ChangeNotifierProvider(create: (_) => ProfileContext()),

      Provider(create: (_) => HomePage()),
      Provider(create: (_) => SheetComponent({}),)
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoppy Staff App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: AuthWrapper(),
    );
  }
}
