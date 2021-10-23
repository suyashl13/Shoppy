import 'package:flutter/material.dart';
import 'package:shoppy/helpers/BackendAuthHelper.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  Map profileData = {};
  bool isError = false;
  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _setProfileData();
  }

  _setProfileData() async {
    await BackendAuthHelper().getProfileData((data) {
      print(data);
      setState(() {
        profileData = data;
        isLoading = false;
      });
    }, (err) {
      setState(() {
        isError = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to load profile.")));
      });
    });
  }

  dispose() {
    super.dispose();
    isError = false;
    isLoading = true;
    isUpdating = false;
  }

  _updateProfileData(Map body) async {
    setState(() {
      isUpdating = true;
    });
    await BackendAuthHelper().updateProfileAtBackend(body, (data) {
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Restart app to see updated profile."),
        backgroundColor: Colors.green,
      ));
    }, (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to update profile."),
        backgroundColor: Colors.red,
      ));
    });
    setState(() {
      isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Center(
          child: Text(
            "Update Profile",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: isError
            ? Center(
                child: Text("Something went wrong"),
              )
            : isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (fName) {
                                setState(() {
                                  profileData['name'] = fName;
                                });
                              },
                              validator: (i) {
                                if (i!.split(' ').length > 1) {
                                  return "Cannot contain spaces.";
                                }
                                if (i.length == 0) {
                                  return "Cannot be empty";
                                }
                              },
                              initialValue: profileData['name'].split(' ')[0],
                              decoration: InputDecoration(
                                  labelText: "First Name",
                                  hintText: "Enter your first name."),
                            ),
                            TextFormField(
                              validator: (i) {
                                if (i!.split(' ').length > 1) {
                                  return "Cannot contain spaces.";
                                }
                                if (i.length == 0) {
                                  return "Cannot be empty";
                                }
                              },
                              onSaved: (lName) {
                                setState(() {
                                  profileData['name'] =
                                      profileData['name'] + ' ' + lName;
                                });
                              },
                              initialValue: profileData['name'].split(' ')[1],
                              decoration: InputDecoration(
                                  labelText: "Last Name",
                                  hintText: "Enter your last name."),
                            ),
                            TextFormField(
                              validator: (email) {
                                if (!email!.contains('@') &&
                                    !email.contains('.')) {
                                  return "Please provide valid email.";
                                }
                                if (email.length == 0) {
                                  return "Cannot be empty";
                                }
                              },
                              onSaved: (email) {
                                profileData['email'] = email;
                              },
                              initialValue: profileData['email'],
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Ex. example@mail.com"),
                            ),
                            TextFormField(
                              validator: (address) {
                                if (address!.length == 0) {
                                  return "Cannot be empty";
                                }
                              },
                              onSaved: (address) {
                                setState(() {
                                  profileData['address'] = address;
                                });
                              },
                              maxLines: 4,
                              initialValue: profileData['address'],
                              decoration: InputDecoration(
                                  labelText: "Address",
                                  hintText: "Enter address"),
                            ),
                            TextFormField(
                              validator: (pincode) {
                                if (pincode!.length != 6) {
                                  return "Please provide valid pincode";
                                }
                              },
                              onSaved: (pincode) {
                                setState(() {
                                  profileData['pincode'] = pincode.toString();
                                });
                              },
                              initialValue: profileData['pincode'],
                              decoration: InputDecoration(
                                  labelText: "Pincode", hintText: "Ex. 411046"),
                            ),
                            SizedBox(
                              height: 42,
                            ),
                            MaterialButton(
                              textColor: Colors.white,
                              color: Colors.green,
                              child: isUpdating
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                          width: 12,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("    Updating Profile.")
                                      ],
                                    )
                                  : Text("Update Profile"),
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  _key.currentState!.save();
                                  profileData.remove('phone');
                                  profileData.remove('id');
                                  profileData.remove('is_active');
                                  profileData.remove('is_staff');
                                  profileData.remove('ref_by');
                                  profileData.remove('reporting_to');
                                  profileData.remove('is_admin_subdealer');
                                  profileData.remove('is_admin_staff');
                                  profileData.remove('is_subdealer');
                                  await _updateProfileData(profileData);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
