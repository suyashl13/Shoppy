// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/FirebaseAuthWrapper.dart';
import 'package:shoppy/helpers/BackendAuthHelper.dart';
import 'package:shoppy/services/FirebaseAuthService.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  late String firstName,
      lastName,
      email,
      password,
      pinCode,
      addressLine1,
      addressLine2,
      addressLine3,
      ref_code,
      phone = "";
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _setVars() async {
    var usr = _firebaseAuth.currentUser;
    password = usr.uid;
    phone = usr.phoneNumber;
  }

  @override
  void initState() {
    super.initState();
    _setVars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Shetkari Basket",
            style: TextStyle(fontSize: 18),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  SharedPreferences _preferences =
                      await SharedPreferences.getInstance();

                  _preferences.clear();
                  await AuthService().signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Initializer(),
                      ));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      children: [
                        Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.green,
                            size: 78,
                          ),
                        ),
                        Text(
                          "Create an account",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) {
                        setState(() {
                          firstName = val!;
                        });
                      },
                      validator: (value) {
                        if (value!.length == 0) {
                          return "This field cannot be empty";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) {
                        lastName = val!;
                      },
                      validator: (value) {
                        if (value!.length == 0) {
                          return "This field cannot be empty";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Last Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) {
                        setState(() {
                          email = val!;
                        });
                      },
                      validator: (value) {
                        if (!value!.contains("@")) {
                          return "Provide a valid email.";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      onSaved: (val) {
                        addressLine1 = val!;
                      },
                      validator: (value) {
                        if (value!.length < 10) {
                          return "This field cannot be smaller than 10 chars";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Address"),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (val) {
                              setState(() {
                                addressLine2 = "(Area : " + val! + ")";
                              });
                            },
                            validator: (value) {
                              if (value!.length == 0) {
                                return "This field cannot be empty";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Area"),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (val) {
                              pinCode = val!;
                              setState(() {
                                addressLine3 = "(PIN : " + val + ")";
                              });
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.length == 0) {
                                return "This field cannot be empty";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Pin Code"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) {
                        setState(() {
                          ref_code = val!;
                        });
                      },
                      maxLength: 8,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "SJE8VP5R",
                           labelText: "Reference Code"),
                    ),
                  ),
                  MaterialButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          print(phone);
                          try {
                            await BackendAuthHelper().createAccountAtBackend(
                                firstName: firstName.trim(),
                                lastName: lastName.trim(),
                                phone: phone.substring(1),
                                email: email.trim(),
                                password: password.trim(),
                                pincode: pinCode.toString().trim(),
                                address: addressLine1 +
                                    "\n" +
                                    addressLine2 +
                                    " " +
                                    addressLine3,
                                ref_code: ref_code,
                                onSuccess: (data) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => Initializer()));
                                },
                                onError: (err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err.toString())));
                                });
                          } catch (e) {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Please try changing email."),
                                actions: [
                                  MaterialButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Ok"))
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Text("Create an Account.")),
                      SizedBox(height: 24,)
                ],
              ),
            ),
          ),
        ));
  }
}
