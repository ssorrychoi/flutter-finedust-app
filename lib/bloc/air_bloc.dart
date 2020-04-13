import 'dart:convert';
import 'package:com/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class AirBloc{

  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc(){
    fetch();
  }
  Future<AirResult> fetchData() async {
    var res = await http.get('https://api.airvisual.com/v2/nearest_city?key=b04d4586-a18e-4a87-9c0c-12629b0c1aa3');

    AirResult result = AirResult.fromJson(json.decode(res.body));
    return result;
  }

  void fetch() async{
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  void refresh(){
    fetch();
  }

  Stream<AirResult> get airResult => _airSubject.stream;
}
