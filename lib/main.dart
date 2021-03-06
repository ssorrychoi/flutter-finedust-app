import 'package:com/models/air_result.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:dotenv/dotenv.dart' show load, env;

import 'bloc/air_bloc.dart';

void main() => runApp(MyApp());

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult _result;

  Object get error => null;

//  Future<AirResult> fetchData() async {
//    var res = await http.get('https://api.airvisual.com/v2/nearest_city?key=b04d4586-a18e-4a87-9c0c-12629b0c1aa3');
//    if(res.statusCode==200){
//      AirResult result = AirResult.fromJson(json.decode(res.body));
//      return result;
//    }else{
//     return Future.error(error);
//    }
//  }

//  RefreshController _refreshController = RefreshController(initialRefresh: false);
//
//  Future<AirResult> _onRefresh() async{
//    var res = await http.get('https://api.airvisual.com/v2/nearest_city?key=b04d4586-a18e-4a87-9c0c-12629b0c1aa3');
//    if(res.statusCode==200){
//      AirResult result = AirResult.fromJson(json.decode(res.body));
//      await Future.delayed(Duration(milliseconds: 1000));
//      _refreshController.refreshCompleted();
//      print(result.data.current.pollution.aqius);
//      return result;
//    }else{
//      await Future.delayed(Duration(milliseconds: 1000));
//      _refreshController.refreshFailed();
//    }
//
//
//    // monitor network fetch
////    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use refreshFailed()
//
////    _refreshController.refreshCompleted();
////    _refreshController.refreshFailed();
//  }

//  void _onLoading() async{
//    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
//    if(mounted)
//      setState(() {
//
//      });
//    _refreshController.loadComplete();
//  }

  //initState
//  @override
//  void initState() {
//    super.initState();
//    fetchData().then((airResult){
//      setState(() {
//        _result = airResult;
//      });
//    });
//    _onRefresh().then((airResult){
//      setState(() {
//        _result = airResult;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Center(
//          enablePullDown: true,
//          onRefresh: airBloc.refresh(),
//          controller: _refreshController,
          child: StreamBuilder<AirResult>(
            stream: airBloc.airResult,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return buildPadding(snapshot.data);
              }else{
                return CircularProgressIndicator();
              }
            }
          ),
        ),
      ),
    );
  }

  Widget buildPadding(AirResult _result) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('현재 위치 미세먼지',style: TextStyle(fontSize: 30,),),
                SizedBox(height: 16,),
                Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: getColor(_result),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('얼굴사진'),
                            Text('${_result.data.current.pollution.aqius}',style: TextStyle(fontSize: 40),),
                            Text(getString(_result),style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.network('https://airvisual.com/images/${_result.data.current.weather.ic}.png',width: 32,height: 32,),
                                SizedBox(width:16),
                                Text('${_result.data.current.weather.tp}℃',style: TextStyle(fontSize: 16),),
                              ],
                            ),
                            Text('습도 ${_result.data.current.weather.hu}%'),
                            Text('풍속 ${_result.data.current.weather.ws}m/s'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                ClipRRect(
                  borderRadius:BorderRadius.circular(30),
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                    color: Colors.orange,
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,),
                    onPressed: () {
                      print('refresh');
                      airBloc.fetch();
                    },
                  ),
                )
              ],
            ),
          ),
        );
  }

 Color getColor(AirResult result) {
    if(result.data.current.pollution.aqius <= 50){
      return Colors.greenAccent;
    }else if(result.data.current.pollution.aqius <= 100){
      return Colors.yellow;
    }else if(result.data.current.pollution.aqius <= 150){
      return Colors.orange;
    }else{
      return Colors.redAccent;
    }
 }

  String getString(AirResult result) {
    if(result.data.current.pollution.aqius <= 50){
      return '좋음';
    }else if(result.data.current.pollution.aqius <= 100){
      return '보통';
    }else if(result.data.current.pollution.aqius <= 150){
      return '나쁨';
    }else{
      return '최악';
    }
  }
}
