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
              decoration: InputDecoration(
                  labelText: "Phone No.", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            MaterialButton(
                child: Text("Login"),
                onPressed: () async => await BackendAuthHelper()
                        .signInAtBackend(
                            credentials: {
                          'phone': '7418529630',
                          'password': 'slaw1113'
                        },
              onSuccess: (res) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthWrapper()));
              },
              onError: (err) {
                print(err);
              }))
            
          ],
        ),
      ),
    );
  }
}
