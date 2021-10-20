// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/services/FirebaseAuthService.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final formKey = new GlobalKey<FormState>();

  late String phoneNo, verificationId, smsCode;

  bool _isLoading = false;
  bool codeSent = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "ShetkariBasket",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 48,
                  ),
                  Column(
                    children: [
                      // Image(
                      //   image: AssetImage("assets/images/basket.png"),
                      //   height: 200,
                      //   width: 200,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Fresh vegetables @\n your door step",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: TextFormField(
                            maxLength: 10,
                            validator: (value) {
                              if (value?.length != 10) {
                                return "Please provide valid phone no.";
                              }
                            },
                            cursorColor: Colors.green,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                labelText: "Phone No.",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: 'Enter phone number'),
                            onChanged: (val) {
                              setState(() {
                                this.phoneNo = val;
                              });
                            },
                          )),
                      codeSent
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 14),
                              child: TextFormField(
                                validator: (value) {
                                  if (value?.length == 0) {
                                    return "Please provide valid OTP";
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "OTP.",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: 'One time password'),
                                onChanged: (val) {
                                  setState(() {
                                    this.smsCode = val;
                                  });
                                },
                              ))
                          : Container(),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 25.0, right: 25.0, top: 12),
                          child: MaterialButton(
                              elevation: 0,
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Center(
                                  child: _isLoading
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        )
                                      : codeSent
                                          ? Text('Login')
                                          : Text('Verify')),
                              onPressed: () async {
                                try {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();
                                    codeSent
                                        ? AuthService().signInWithOTP(
                                            smsCode, verificationId)
                                        : verifyPhone(phoneNo);
                                  }
                                } catch (e) {
                                  return await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Alert"),
                                      content: Text(e.toString()),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                codeSent = false;
                                              });
                                            },
                                            child: Text("OK"))
                                      ],
                                    ),
                                  );
                                }
                              }))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    setState(() {
      _isLoading = true;
    });

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed = (authException) {
      setState(() {
        _isLoading = false;
      });
      print(authException.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authException.message.toString())));
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      this.verificationId = verId;
      setState(() {
        _isLoading = false;
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      print("************ Time Out ************");
      setState(() {
        _isLoading = false;
      });
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + phoneNo,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable To Login.."),
      ));
    }
  }
}
