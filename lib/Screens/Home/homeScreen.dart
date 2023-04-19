import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluster/fluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

final MapController _mapController = MapController();
final LatLng initialLocation = LatLng(55.9125188597277, -3.32137120930613);

class MyIcon extends Clusterable {
  LatLng position;

  MyIcon(this.position);

}


class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _ListState();

}

class _ListState extends State<homeScreen> {
  List<LatLng> MyIcon = [];

  late Future<voltageAlbum> futureVAlbum;
  late Future<releaseAlbum> futureRAlbum;
  late Future<distanceAlbum> futureDAlbum;


  void _getVoltage() {
    var api = voltageAPI();
    futureVAlbum = api.fetchAlbum();
  }
  void _releaseTrap() {
    var api = releaseAPI();
    futureRAlbum = api.fetchAlbum();
  }
  void _getDistance() {
    var api = distanceAPI();
    futureDAlbum = api.fetchAlbum();
  }



  @override
  Widget build(BuildContext context) {
    final markers = MyIcon.map((position) {
      return Marker(
          width: 80,
          height: 80,
          point: position,
          builder: (ctx) => IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Trap Information'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                          ElevatedButton(
                          child: Text("Get Trap Distance", style: TextStyle(fontSize: 20)),
                          onPressed: () {
                           _getDistance();
                           Navigator.pop(context, 'Exit');
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Background color
                              foregroundColor: Colors.white, // Text Color (Foreground color)
                            ),
                          ),
                              ElevatedButton(
                                child: Text("Check Battery Level", style: TextStyle(fontSize: 20),),
                                onPressed: () {
                                  _getVoltage();
                                  Navigator.pop(context, 'Exit');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Background color
                                  foregroundColor: Colors.white, // Text Color (Foreground color)
                                ),
                              ),
                              ElevatedButton(
                                child: Text("Release Trap", style: TextStyle(fontSize: 20),),
                                onPressed: ()  {
                                  _releaseTrap();
                                  Navigator.pop(context, 'Exit');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Background color
                                  foregroundColor: Colors.white, // Text Color (Foreground color)
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text("Exit"),
                          onPressed: () {
                            Navigator.pop(context, 'Exit');

                          },

                        )
                      ],
                    );
                  });
            },
            icon: Icon(Icons.flag_circle_rounded),
            color: Colors.blue,

          )
      );
    }).toList();


    return Scaffold(
       appBar: AppBar(title: Text("Home Screen")),
        body: Center(
          child: Stack(
            children: <Widget>[
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(55.9125188597277, -3.32137120930613),
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                      markers: markers
                  )

                ],

              ),
            ],
          ),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 640),

          child: Column (
            children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Trap Setup'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'User ID',
                                          icon: Icon(Icons.account_box),
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          icon: Icon(Icons.lock),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text("Submit"),  onPressed: () async {
                                  Navigator.pop(context, 'submit');
                                  _getCurrentLocation();
                                  addMarker(LatLng(x, y));
                                },

                                )
                              ],
                            );
                          });
                    }

                ),
              ),

              FloatingActionButton(
                  child: const Icon(Icons.directions_boat_outlined),
                  onPressed: () {
                    _getCurrentLocation();
                    var response = _mapController.move(LatLng(x, y),15);
                    //sets location on screen when pressed to original/user position
                  }
              )],
          ),
        )
    );


  }

  var x;
  var y;


void _getCurrentLocation() async {

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);

  x = position.latitude;
  y = position.longitude;

  print (x);
  print (y);

  //testing to confirm x and y have crrect values
  }

  void addMarker(LatLng){
    setState(() {
      _getCurrentLocation();
      MyIcon.add(LatLng);
    }
    );
  }
}


class distanceAlbum {
  final int ack;
  final int distance;

  const distanceAlbum({
    required this.ack,
    required this.distance,
  });

  factory distanceAlbum.fromJson(Map<String, dynamic> json) {
    return distanceAlbum(
      ack: json['ack'],
      distance: json['distance'],
    );
  }
}
class distanceAPI {

  Future<distanceAlbum> fetchAlbum() async {
    final response = await http
    // URL here would be 'http://$ip/$command/?id=$id'
        .get(Uri.parse('http://192.168.4.1/ping/?id=123'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return distanceAlbum.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class voltageAlbum {
  final int ack;
  final int voltage;

  const voltageAlbum({
    required this.ack,
    required this.voltage,
  });

  factory voltageAlbum.fromJson(Map<String, dynamic> json) {
    return voltageAlbum(
      ack: json['ack'],
      voltage: json['voltage'],
    );
  }
}

class voltageAPI {

  Future<voltageAlbum> fetchAlbum() async {
    final response = await http
    // URL here would be 'http://$ip/$command/?id=$id'
        .get(Uri.parse('http://192.168.4.1/voltage/?id=123'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return voltageAlbum.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}


class releaseAlbum {
  final int ack;

  const releaseAlbum({
    required this.ack,
  });

  factory releaseAlbum.fromJson(Map<String, dynamic> json) {
    return releaseAlbum(
      ack: json['ack'],
    );
  }
}

class releaseAPI {


  Future<releaseAlbum> fetchAlbum() async {
    final response = await http

        .get(Uri.parse('http://192.168.4.1/release/?id=123'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return releaseAlbum.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}