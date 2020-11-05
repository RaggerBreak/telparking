import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Barrier {
   String name;
   String phoneNumber;
   Position position;

  Barrier({this.name, this.phoneNumber, this.position});
}

var barriers = [
  Barrier(name: "Wapienna", phoneNumber: "111111", position: Position(latitude: 51.234590, longitude: 22.545897)),
  Barrier(name: "WZ", phoneNumber: "222222", position:Position(latitude: 51.234952, longitude: 22.549711)),
  Barrier(name: "Centech", phoneNumber: "333333", position: Position(latitude: 51.236386, longitude: 22.547813))
];

double _distanceFrom(Position a, Position b) {
  return Geolocator.distanceBetween(
      a.latitude, a.longitude, b.latitude, b.longitude);
}

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

  Barrier nearestBarrier = new Barrier();
  bool _visibleButton = false;

  void _nearestBarrier() async {
    var currentPosition = await Geolocator.getCurrentPosition();

    barriers.sort((a, b) =>
        _distanceFrom(currentPosition, a.position).compareTo(_distanceFrom(currentPosition, b.position)));

    setState(() {
      nearestBarrier = barriers.first;
    });

    launcher.launch("tel://${nearestBarrier.phoneNumber}");
  }

  void _checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      setState(() {
        _visibleButton = true;
      });
    }
    else
      setState(() {
        _visibleButton = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    _checkLocationPermission();
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
        ),
        floatingActionButton: Visibility(
              child:  FloatingActionButton(
                onPressed: _nearestBarrier,
                child: Icon(Icons.gps_fixed),
              ),
          visible: _visibleButton,
            )
    );
  }
}
