import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_app/config/Env.dart';
import 'package:http/http.dart' as http;

class BackendAuthHelper {
  // ignore: non_constant_identifier_names
  final String BASE_URL = Env().BASE_URL;
  late SharedPreferences _preferences;

  Future<void> verifyAuth(
      {required onSuccess(res), required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();

    if (_preferences.getString('jwt') == null) {
      onSuccess(false);
      return;
    }

    try {
      await http.get(
          Uri.parse(
              "${BASE_URL}users/check_session/${_preferences.get('phone')}/"),
          headers: {
            'Authorization': _preferences.getString("jwt").toString()
          }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body)['exists']);
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err.toString();
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      onError(e);
    }
  }

  Future<void> signInAtBackend(
      {required Map credentials,
      required onSuccess(res),
      required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http
          .post(Uri.parse('${BASE_URL}users/login/'), body: credentials)
          .then((res) {
        if (res.statusCode == 200) {
          _preferences.setString('jwt', jsonDecode(res.body)['jwt']);
          _preferences.setString('phone', jsonDecode(res.body)['user']['name']);
          _preferences.setString(
              'phone', jsonDecode(res.body)['user']['phone']);
          onSuccess(jsonDecode(res.body));
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

  Future<void> createAccountAtBackend(
      {required Map newUserData,
      required onSuccess(res),
      required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http
          .post(Uri.parse(BASE_URL + 'users/'), body: newUserData)
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err;
      });
    } catch (e) {
      onError(e);
    }
  }

  Future<void> signOutAtBackend(
      {required onSuccess(res), required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http.get(Uri.parse(BASE_URL + 'users/logout/'), headers: {
        'Authorization': _preferences.getString("jwt").toString()
      }).then((res) {
        if (res.statusCode == 200) {
          _preferences.clear();
          onSuccess(jsonDecode(res.body));
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err;
      }).timeout(Duration(seconds: 20));
    } catch (e) {
      onError(e.toString());
    }
  }
}
