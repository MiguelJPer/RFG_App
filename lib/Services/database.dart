import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference data = FirebaseFirestore.instance.collection('Data');

  void updateUserData(String? uid, String dev_id, int latlong) {
    data.add({
      'uid': uid,
      'dev_id': dev_id,
      'loc': latlong,
    });
  }

}