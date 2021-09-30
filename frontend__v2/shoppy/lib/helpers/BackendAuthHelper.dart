import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/Env.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class BackendAuthHelper {
  final BASE_URL = Env().BASE_URL;
  late SharedPreferences sharedPref;

  checkUserExsistance(
      String phoneNo, onSuccess(isExsist), onError(error)) async {
    try {
      await http
          .get(Uri.parse(BASE_URL + "users/check_user/$phoneNo/"))
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body)['exists']);
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e);
    }
  }

  checkUserSession(String phoneNo, onSuccess(isExsist), onError(error)) async {
    sharedPref = await SharedPreferences.getInstance();
    try {
      await http.get(Uri.parse(BASE_URL + 'users/check_session/$phoneNo/'),
          headers: {
            'Authorization': sharedPref.getString('jwt').toString()
          }).then((res) {
        Map data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          onSuccess(data['exists']);
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e);
    }
  }

  createAccountAtBackend(
      {firstName,
      lastName,
      phone,
      email,
      password,
      pincode,
      address,
      ref_code,
      required onSuccess(data),
      required onError(error)}) async {
    sharedPref = await SharedPreferences.getInstance();
    Map formData = new Map();

    formData['name'] = firstName + " " + lastName;
    formData['email'] = email;
    formData['phone'] = phone;
    formData['pincode'] = pincode;
    formData['password'] = password;
    formData['is_subdealer'] = 'false';
    formData['address'] = address;
    formData['ref_code'] = ref_code == null ? "" : ref_code;

    try {
      await http
          .post(
        Uri.parse(BASE_URL + "users/"),
        body: formData,
      )
          .then((res) async {
        Map data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          sharedPref.setString('jwt', data['jwt']);
          sharedPref.setString('name', data['user']['name']);
          onSuccess(data);
        } else {
          throw data['ERR'];
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (err) {
      onError(err);
    }
  }

  loginAtBackend(
      String phone, String password, onSuccess(res), onError(err)) async {
    sharedPref = await SharedPreferences.getInstance();
    try {
      await http.post(Uri.parse(BASE_URL + 'users/login/'),
          body: {'phone': phone, 'password': password}).then((res) {
        if (res.statusCode == 200) {
          Map data = jsonDecode(res.body);
          sharedPref.setString('jwt', data['jwt']);
          sharedPref.setString('name', data['user']['name']);
          onSuccess(res);
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((onError) {
        throw onError.toString();
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  logoutAtBackend(onSuccess(data), onError(err)) async {
    sharedPref = await SharedPreferences.getInstance();

    try {
      await http.get(Uri.parse(BASE_URL + 'users/logout/'), headers: {
        'Authorization': sharedPref.getString('jwt').toString()
      }).then((res) {
        if (res.statusCode == 200) {
          sharedPref.clear();
          onSuccess(jsonDecode(res.body)['INFO']);
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e);
    }
  }

  updateProfileAtBackend(Map body, onSuccess(data), onError(err)) async {
    sharedPref = await SharedPreferences.getInstance();
    try {
      await http.put(
        Uri.parse(BASE_URL + 'users/${sharedPref.getString('jwt').toString().split('.')[0]}/'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': sharedPref.getString("jwt").toString()  
        },
        body: body,
        encoding: Encoding.getByName('utf-8')
      ).then((res) {
        if (res.statusCode == 200) {
          sharedPref.setString('name', jsonDecode(res.body)['name']);
          onSuccess(res.body);
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((onError) {
        throw onError;
      });
    } catch (e) {
      onError(e);
    }  

  }

  getProfileData(onSuccess(data), onError(err)) async {
    sharedPref = await SharedPreferences.getInstance();
    
    try {
      await http.get(
      Uri.parse(BASE_URL + 'users/${sharedPref.get('jwt').toString().split('.')[0]}/'),
      headers: {
        'Authorization': sharedPref.getString("jwt").toString()
      }
    ).then((res) {
      if (res.statusCode == 200) {
        onSuccess(jsonDecode(res.body));
      } else {
        throw jsonDecode(res.body)['ERR'];
      }
    }).catchError((onError){throw onError.toString();});
    } catch (e) {
      onError(e);
    }
  }
}
