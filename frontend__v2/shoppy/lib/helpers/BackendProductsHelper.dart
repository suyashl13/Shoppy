import 'dart:convert';

import 'package:http/http.dart';
import 'package:shoppy/Env.dart';

import 'package:http/http.dart' as http;

class BackendProductsHelper {
  final String BASE_URL = Env().BASE_URL;

  getAvailableProducts(onSuccess(data), onError(err)) async {
    try {
      http.get(Uri.parse(BASE_URL + 'products/'))
    .then((res) {
      if (res.statusCode == 200) {
        onSuccess(jsonDecode(res.body));
      } else {
        throw jsonDecode(res.body)['ERR'];
      }
    })
    .catchError((err) {
      throw err.toString();
    });
    } catch (e) {
      onError(e.toString());
    }
  }


}