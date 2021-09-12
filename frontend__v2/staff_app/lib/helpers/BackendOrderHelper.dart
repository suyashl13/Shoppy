import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_app/config/Env.dart';

class BackendOrderHelper {
  // ignore: non_constant_identifier_names
  final BASE_URL = Env().BASE_URL;
  late SharedPreferences _preferences;

  Future getDeliverableCartsFromBackend({required onSuccess(data), required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();

    try {
      await http.get(Uri.parse(BASE_URL + 'carts/staff/'), headers: {
        'Authorization': _preferences.get('jwt').toString(),
      }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((err) {
        throw err;
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  Future updateCartAtBackend(
      {required int cartId, required Map cartUpdate}) async {
    _preferences = await SharedPreferences.getInstance();

    await http
        .put(Uri.parse(BASE_URL + 'carts/staff/$cartId/'),
            headers: {
              "Authorization": _preferences.get('jwt').toString(),
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: cartUpdate,
            encoding: Encoding.getByName('utf-8'))
        .then((res) {
      print(res.body);
    }).catchError((err) {
      print(err);
    });
  }
}
