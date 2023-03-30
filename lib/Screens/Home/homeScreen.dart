import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluster/fluster.dart';
import 'package:geolocator/geolocator.dart';

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
                      title: Text('Trap Releaase'),
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
                          child: Text("Submit"),
                          onPressed: () {
                            Navigator.pop(context, 'submit');
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
                      _getCurrentLocation();
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
                    var response = _mapController.move(LatLng(55.9125188597277, -3.32137120930613),15);
                    //sets location on screen when pressed to original/user position
                  }
              )],
          ),
        )
    );


  }



  void addMarker(userLocation){
    setState(() {
      MyIcon.add(userLocation);
    }
    );
  }
}



Position? position;
void _getCurrentLocation() async {

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);
  }
//abj
