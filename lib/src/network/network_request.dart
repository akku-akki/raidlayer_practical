import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:raidlayer_practical/src/network/url.dart';

import 'exception.dart';

import 'dart:convert' as convert;

const token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvc3RvcmUuY3liZXJsb2JlLmNvbSIsImlhdCI6MTYwOTgyMjk5MSwibmJmIjoxNjA5ODIyOTkxLCJleHAiOjE2MTA0Mjc3OTEsImRhdGEiOnsidXNlciI6eyJpZCI6IjczIn19fQ.Kk3swkswzY7WXQHWeh5S5HJ96Rw3neuV3yn8pGvpZI1";

class NetworkRequest {
  Future<String> verifyToken() async {
    bool result = false;
    String color = '';
    try {
      var response = await http.post(NetworkUrl.Token_Verification_API,
          body: {'subscription_id': '124', 'jwt_token': token});
      if (response.statusCode == 429) throw Exception("Too many request");
      if (response.statusCode == 200) {
        var body = convert.jsonDecode(response.body);
        result = body['status'];
        if (result == true) {
          color = await _fetchBackGroundColor();
        } else {
          throw Exception("Verification Failed");
        }
      }
      return color;
    } on SocketException {
      throw Faliures.noInternet;
    } on HttpException {
      throw Faliures.httpError;
    } on FormatException {
      throw Faliures.invalidFormat;
    }
  }

  Future<String> _fetchBackGroundColor() async {
    String color;
    try {
      var response = await http
          .post(NetworkUrl.App_Settings_API, body: {'subscription_id': '124'});
      if (response.statusCode == 429) throw Exception("Too many request");
      if (response.statusCode == 200) {
        var body = convert.jsonDecode(response.body);
        color = body['background_color'];
      }
      return color ?? 'ffffffff'; // Returning Default if null
    } on SocketException {
      throw Faliures.noInternet;
    } on HttpException {
      throw Faliures.httpError;
    } on FormatException {
      throw Faliures.invalidFormat;
    }
  }
}
