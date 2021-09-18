import 'package:flutter/material.dart';
import 'package:staff_app/helpers/BackendAuthHelper.dart';
import 'package:staff_app/screens/home/HomePage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _obsecure = true;
  Map newProfileMap = {
    'name': '',
    'email': '',
    'password': '',
    'phone': '',
    'address': '',
    'pincode': '',
    'subdealer_code': '',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    onSaved: (val) {
                      setState(() {
                        newProfileMap['name'] = val;
                      });
                    },
                    validator: (val) {
                      if (val!.length < 3) {
                        return "Should be > 3 characters.";
                      }
                    },
                    decoration: InputDecoration(labelText: "First Name"),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                      child: TextFormField(
                    onSaved: (val) {
                      setState(() {
                        newProfileMap['name'] =
                            newProfileMap['name'] + ' ' + val;
                      });
                    },
                    validator: (val) {
                      if (val!.length < 3) {
                        return "Should be > 3 characters.";
                      }
                    },
                    decoration: InputDecoration(labelText: "Last Name"),
                  )),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onSaved: (val) {
                  setState(() {
                    newProfileMap['phone'] = val;
                  });
                },
                validator: (val) {
                  if (val!.length != 10) {
                    return "Should be 10 characters.";
                  }
                },
                decoration: InputDecoration(labelText: "Phone No."),
              ),
              TextFormField(
                onSaved: (val) {
                  newProfileMap['email'] = val;
                },
                validator: (val) {
                  if (!val!.contains('@') && !val.contains('.')) {
                    return "Please provide valid email address.";
                  }
                },
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                maxLines: 3,
                onSaved: (val) {
                  setState(() {
                    newProfileMap['address'] = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 10) {
                    return "Should be atleast 10 characters.";
                  }
                },
                decoration: InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    newProfileMap['password'] = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 6) {
                    return "Should be atleast 6 characters.";
                  }
                },
                obscureText: _obsecure,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obsecure = !_obsecure;
                        });
                      },
                      child: Icon(Icons.remove_red_eye_rounded)),
                ),
              ),
              TextFormField(
                validator: (val) {
                  print(newProfileMap['password'] + " : " + val);
                  if (newProfileMap['password'] != val) {
                    return "Password doesnot match.";
                  }
                },
                obscureText: _obsecure,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecure = !_obsecure;
                          });
                        },
                        child: Icon(Icons.remove_red_eye)),
                    labelText: "Confirm Password"),
              ),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    onSaved: (val) {
                      newProfileMap['pincode'] = val;
                    },
                    validator: (val) {
                      if (val!.length != 6) {
                        return "Should be 6 characters.";
                      }
                    },
                    decoration: InputDecoration(labelText: "Postal Pincode"),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                      child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    onSaved: (val) {
                      setState(() {
                        newProfileMap['subdealer_code'] = val;
                      });
                    },
                    maxLength: 8,
                    validator: (val) {
                      if (val!.length != 8) {
                        return "Should be 8 characters.";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "Subdealer Ref. Code"),
                  )),
                ],
              ),
              Container(
                width: double.maxFinite,
                child: MaterialButton(
                  color: Colors.green,
                  elevation: 0.1,
                  textColor: Colors.white,
                  child: Text("Create Account"),
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      print(newProfileMap);
                      await BackendAuthHelper().createAccountAtBackend(
                          newUserData: newProfileMap,
                          onSuccess: (data) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => HomePage()));
                          },
                          onError: (err) {
                            print(err);
                          });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
