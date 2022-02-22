import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nextflow_covid_today/covid_today_result.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Today',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'COVID-19 Today'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
 CovidTodayResult _dataFromWebAPI;

 @override
 void initState() {
   super.initState();

    print('init state');
    getData();
 }

 Future<void> getData() async {
    print('get data');
    var response = await http.get('https://covid19.ddc.moph.go.th/api/Cases/today-cases-all');
    print(response.body);

    setState(() {
      _dataFromWebAPI = covidTodayResultFromJson(response.body) as CovidTodayResult;
    });
    
 }

  @override
  Widget build(BuildContext context) {

    print('build');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Date'),
            subtitle: Text('${_dataFromWebAPI?.txnDate ?? "..."}'), 
          ),
          ListTile(
            title: Text('ผู้ติดเชื้อสะสม'),
            subtitle: Text('${_dataFromWebAPI?.newCase ?? "..."}'), 
          ),
          ListTile(
            title: Text('หายแล้ว'),
            subtitle: Text('${_dataFromWebAPI?.newRecovered ?? "..."}'), 
          ),
          ListTile(
            title: Text('รักษาอยู่ในโรงพยาบาล'),
            subtitle: Text('${_dataFromWebAPI?.newCaseExcludeabroad ?? "..."}'), 
          ),
          ListTile(
            title: Text('เสียชีวิต'),
            subtitle: Text('${_dataFromWebAPI?.newDeath ?? "..."}'), 
          )
        ],
      )
    );
  }
}
