import 'package:flutter/material.dart';
import 'package:staff_app/helpers/BackendAuthHelper.dart';
import 'package:staff_app/screens/auth/AuthenticationPage.dart';
import 'package:staff_app/screens/home/HomePage.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  _setPage() async {
    await BackendAuthHelper().verifyAuth(onSuccess: (res) {
      if (res) {
        setState(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage()));
          isLoading = false;
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AuthenticationPage()));
      }
    }, onError: (err) {
      setState(() {
        isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isError)
                Center(child: Text("Something went wrong..."))
              else
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text("Redirecting...")
            ],
          ),
        ),
      );
}
