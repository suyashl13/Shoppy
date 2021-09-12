import 'package:flutter/material.dart';
import 'package:staff_app/screens/auth/SignIn.dart';
import 'package:staff_app/screens/auth/SignUp.dart';

class AuthenticationPage extends StatelessWidget {
  final children = [SignUp(), SignIn()];

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Shoppy Staff", style: TextStyle(fontSize: 18),),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Sign - Up",
              ),
              Tab(
                text: "Sign - In",
              ),
            ],
          ),
        ),
        body: TabBarView(children: children),
      ));
}
