// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:com/models/air_result.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:dotenv/dotenv.dart' show load, env;


void main() {
  test('http 통신 테스트',() async {
    load();
    print('${env['API_KEY']}');
    var res = await http.get('https://api.airvisual.com/v2/nearest_city?key=${env['API_KEY']}');
//    var res = await http.get('https://api.airvisual.com/v2/nearest_city?key=b04d4586-a18e-4a87-9c0c-12629b0c1aa3');
    expect(res.statusCode,200);
    print('-----');
    print(res);
    print(res.statusCode);

    AirResult result = AirResult.fromJson(json.decode(res.body));
    expect(result.status,'success');
    print('-----');
    print(result);
    print(result.status);
  });

}
