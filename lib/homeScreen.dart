import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluster/fluster.dart';



class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _ListState();
}

class _ListState extends State<homeScreen> {
  List<LatLng> markerPoints = [];

  @override
  Widget build(BuildContext context) {
    final markers = markerPoints.map((latlng) {
      return Marker(
          width: 80,
          height: 80,
          point: latlng,
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
                            addMarker(LatLng(55.9125188597277, -3.32137120930613));
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

      floatingActionButton: FloatingActionButton(
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
                        child: Text("Submit"),
                        onPressed: () {
                          Navigator.pop(context, 'submit');
                          addMarker(LatLng(55.9125188597277, -3.32137120930613));
                        },

                      )
                    ],
                  );
                });
          }),
    );


  }

  void addMarker(LatLng latlng){
    setState(() {
      markerPoints.add(latlng);
    }
    );
  }

}