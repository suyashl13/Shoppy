import 'package:flutter/material.dart';
import 'package:staff_app/AuthWrapper.dart';
import 'package:staff_app/helpers/BackendAuthHelper.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  Map credentials = {
    'phone': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 34),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 10,
              onChanged: (val) {
                setState(() {
                  credentials['phone'] = val;
                });
              },
              decoration: InputDecoration(
                  labelText: "Phone No.", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  credentials['password'] = val;
                });
              },
              decoration: InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              width: double.maxFinite,
              child: ElevatedButton(
                  child: Text("Login"),
                  onPressed: () async =>
                      await BackendAuthHelper().signInAtBackend(
                          credentials: credentials,
                          onSuccess: (res) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => AuthWrapper()));
                          },
                          onError: (err) {
                            ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.red,));
                          })),
            )
          ],
        ),
      ),
    );
  }
}
