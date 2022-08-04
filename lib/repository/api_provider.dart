import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:weatherapp/repository/api_exception.dart';


class ApiProvider {
  Future<dynamic> getRequest(String path) async {
    Response response;
    try {
      response = await get(Uri.parse(path),
        headers: {
          'content-type':'application/json',
        },);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        if (response.body.isEmpty) {
          return [];
        } else {
          return jsonDecode(response.body);
        }
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }
    } on SocketException {
      throw ConnectionException();
    }
  }

}