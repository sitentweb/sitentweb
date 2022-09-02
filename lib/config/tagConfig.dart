import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagConfig {


  static addNewTag(tag) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.get("tagsList") != null){

      List tagList = pref.getStringList("tagsList");

      tagList.add(tag);

      pref.setStringList("tagsList", tagList);

    }else{

      List tagList = [];

      tagList.add(tag);

      pref.setStringList("tagsList", tagList);

    }

  }

  static showTags() async {

    Iterable<String> tagList = [];

    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.get("tagsList") != null){

      tagList = pref.getStringList('tagsList');

    }

    return tagList;

  }

}