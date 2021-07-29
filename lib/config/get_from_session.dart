import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSession {

    static Future getKey(String key) async {
      String value;
      SharedPreferences pref = await SharedPreferences.getInstance();

      value = pref.getString(key);

      return value;

    }
}