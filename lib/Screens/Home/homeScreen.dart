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

  late Future<Album> futureAlbum;
  late String order = "";

  /*
  Creates a new API and updates futureAlbum. Called each time a button is called.
  In the actual code it will have an "Order" input to change the fetchAlbum() order.
  */
  void _getAlbum() {
    var api = DeviceAPI();
    futureAlbum = api.fetchAlbum();
  }

  /*
  Updates the FutureBuilder widget that shows the information by retrieving the
  correct data from the Album according to the input order, else it returns
  an empty string.
  */
  Widget _getProperWidget(String order) {
    if (order != "") {
      return FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (order == "ack") {
              return Text(
                snapshot.data!.ack.toString(),
                textAlign: TextAlign.center,
              );
            }
            if (order == "distance") {
              return Text(
                snapshot.data!.distance.toString(),
                textAlign: TextAlign.center,
              );
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      );
    } else {
      return const Text("");
    }
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
                          child: Text("Get User ID"),
                          onPressed: () {
                            setState(() {
                              order = "userID";
                            });
                            _getAlbum();
                          },
                          ),
                              ElevatedButton(
                                child: Text("Get Trap ID"),
                                onPressed: () {
                    setState(() {
                    order = "id";
                    });
                    _getAlbum();


                                },
                              ),
                              ElevatedButton(
                                child: Text("Release Trap"),
                                onPressed: ()  {
                                  _releaseTrap();
                                  _getAlbum();
                                },
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




class DeviceAPI {
  static const id = "123";
  /*
  Function to perform GET request with input String "Order" that changes the
  $command variable depending on the button pressed. Returns an Album with the
  GET response.
   */
  Future<Album> fetchAlbum() async {
    final response = await http
    // URL here would be 'http://$ip/$command/?id=$id'
        .get(Uri.parse('http://192.168.4.1/release/?id=123'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}


void _releaseTrap() async{
  const id = "123";

  Future<Album> fetchAlbum() async {
    final response = await http
    // URL here would be 'http://$ip/$command/?id=$id'
        .get(Uri.parse('http://192.168.4.1/release/?id=123'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Album {
  final int ack;
  final int distance;


  const Album({
    required this.ack,
    required this.distance,

  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      ack: json['ack'],
      distance: json['distance'],

    );
  }
}



