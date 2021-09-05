import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/services/FirebaseAuthService.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late SharedPreferences _pref;

    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                  child: Image.asset(
                'assets/images/connection_lost.png',
                scale: 5.8,
              )),
              Padding(
                padding: EdgeInsets.all(26),
                child: Text(
                  "Connection Lost",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Connection Lost. Please check your Internet connection, or wait for a while it might be a server down issue.", textAlign: TextAlign.center,),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(26.0),
                child: Text("OR"),
              ),
              MaterialButton(
                textColor: Colors.white,
                elevation: 0,
                color: Colors.blue,
                child: Text("Logout"),
                onPressed: () async {
                  _pref = await SharedPreferences.getInstance();
                  AuthService().signOut();
                  _pref.clear();
                  
                })
            ],
          )
        ],
      )),
    );
  }
}
