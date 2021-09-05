// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/helpers/BackendAuthHelper.dart';
import 'package:shoppy/screens/ContainerPage.dart';
import 'package:shoppy/screens/auth/AuthenticationPage.dart';
import 'package:shoppy/screens/auth/CreateAccountPage.dart';
import 'package:shoppy/services/FirebaseAuthService.dart';

class FirebasebaseAuthWrapper extends StatefulWidget {
  @override
  _FirebasebaseAuthWrapperState createState() =>
      _FirebasebaseAuthWrapperState();
}

class _FirebasebaseAuthWrapperState extends State<FirebasebaseAuthWrapper> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Initializer();
        } else {
          return AuthenticationPage();
        }
      },
    );
  }
}

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _redirectUserAccordingtoAuthScenario();
  }

  _redirectUserAccordingtoAuthScenario() async {
    String phoneNo = firebaseAuth.currentUser.phoneNumber.substring(1);

    await BackendAuthHelper().checkUserExsistance(phoneNo, (isExsist) {
      if (isExsist) {
        _checkSessionAndRedirectUser(phoneNo);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => CreateAccountPage()));
      }
    }, (error) {
      print(error);
    });
  }

  _checkSessionAndRedirectUser(String phoneNo) async {
    await BackendAuthHelper().checkUserSession(phoneNo, (isSessionExsist) {
      if (isSessionExsist) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => ContainerPage()));
      } else {
        FirebaseAuth.instance.userChanges().listen((user) {
          BackendAuthHelper()
              .loginAtBackend(user.phoneNumber.substring(1), user.uid, (res) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ContainerPage()));
          }, (err) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("App Initialization error.")));
          });
        });
      }
    },
    (error) {
      print(error);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("App Initialization error.")));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.maxFinite,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Icon(
                    Icons.shopping_basket,
                    color: Colors.green,
                    size: 82,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: LinearProgressIndicator(),
                )
              ],
            ),
          )),
    );
  }
}
