import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:http/http.dart';

class DictionaryController extends GetxController {
  Response? response;
  String url = "https://owlbot.info/api/v4/dictionary/";
  String token = "your api here";

  TextEditingController dictionaryText = TextEditingController();

  late StreamController _streamController;
  late Stream stream;
  var error;

  Timer? debounce;

  search() async {
    if (dictionaryText.text.isEmpty) {
      _streamController.add(null);
      return;
    }

    _streamController.add("isLoading");

    Response response = await get(Uri.parse(url + dictionaryText.text.trim()),
        headers: {"Authorization": "Token $token"});
    _streamController.add(json.decode(response.body));
    log("showing data ========================${response.body}");
    error = response.body;
  }

  @override
  void onInit() {
    super.onInit();
    _streamController = StreamController();
    stream = _streamController.stream;
  }
}
