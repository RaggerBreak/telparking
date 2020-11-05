import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:geolocator/geolocator.dart';

class Barrier {
  final String name;
  final String phoneNumber;
  final Position position;

  Barrier({this.name, this.phoneNumber, this.position});
}

var barriers = [
  Barrier(name: "Wapienna", phoneNumber: "111111", position: Position(latitude: 51.234590, longitude: 22.545897)),
  Barrier(name: "WZ", phoneNumber: "222222", position:Position(latitude: 51.234952, longitude: 22.549711)),
  Barrier(name: "Centech", phoneNumber: "333333", position: Position(latitude: 51.236386, longitude: 22.547813))
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kontakty")),
        body: ListView.builder(
          itemCount: barriers.length,
          itemBuilder: (context, index) {
            var barrier = barriers[index];

            return ListTile(
              title: Text(barrier.name),
              onTap: () {
                launcher.launch("tel://${barrier.phoneNumber}");
              },
            );
          },
        ));
  }
}
