import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/Env.dart';

class BackendCartsHelper {
  // ignore: non_constant_identifier_names
  String BASE_URL = Env().BASE_URL;
  late SharedPreferences _pref;

  getUserCarts(onSuccess(data), onError(err)) async {
    // TODO: Fix the callback bug.
    _pref = await SharedPreferences.getInstance();

    try {
      await http.get(Uri.parse("${BASE_URL}carts/"), headers: {
        'Authorization': _pref.getString("jwt").toString()
      }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else {
          throw jsonDecode(res.body)['ERR'];
        }
      }).catchError((onError) {
        throw onError.toString();
      });
    } catch (e) {
      onError(e);
    }
  }

  makeOrderAtBackend(
      List cartItems, Map optionalAddress, onSuccess(), onError(err)) async {
    _pref = await SharedPreferences.getInstance();

    late int cartId;

    try {
      await http
          .post(Uri.parse(BASE_URL + 'carts/'),
              headers: {'Authorization': _pref.getString("jwt").toString()}, 
              body: optionalAddress)
          .then((res) {
        if (res.statusCode == 200) {
          cartId = jsonDecode(res.body)['id'];
        } else {
          throw 'Unable to create cart.';
        }
      });
    } catch (e) {
      onError(e);
    }

    try {
      for (Map cartItem in cartItems) {
        await http.post(Uri.parse(BASE_URL + 'carts/${cartId.toString()}/'),
            headers: {
              'Authorization': _pref.getString("jwt").toString()
            },
            body: {
              'product': cartItem['id'].toString(),
              'quantity': cartItem['quantity'].toString()
            }).then((res) {
          if (res.statusCode != 200) {
            throw jsonDecode(res.body)['ERR'];
          }
        }).catchError((e) {
          throw e;
        });
      }
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  cancelOrder(int cartId, onSuccess(data), onError(err)) async {
    _pref = await SharedPreferences.getInstance();

    try {
      await http
          .put(
        Uri.parse(BASE_URL + "carts/${cartId.toString()}/"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': _pref.getString("jwt").toString()
        },
        body: {'is_cancelled': 'true'},
        encoding: Encoding.getByName('utf-8'),
      )
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else
          throw jsonDecode(res.body)['ERR'];
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  verifyOrder(int cartId, onSuccess(data), onError(err)) async {
    _pref = await SharedPreferences.getInstance();

    try {
      await http
          .put(
        Uri.parse(BASE_URL + "carts/${cartId.toString()}/"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': _pref.getString("jwt").toString()
        },
        body: {'is_verified': 'true'},
        encoding: Encoding.getByName('utf-8'),
      )
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else
          throw jsonDecode(res.body)['ERR'];
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e.toString());
    }
  }

}
