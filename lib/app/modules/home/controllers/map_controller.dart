import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MapController extends GetxController {
  final firestore = FirebaseFirestore.instance;

  CollectionReference get getMapCollection => firestore.collection('Map');

Future<void>  storeCurrentLocation({required double lat, required double lng}) async {
    await getMapCollection.doc('jamalshahzee').set({
      'Lat': lat,
      'Lng': lng,
    });
  }
 
Future<void>  updateCurrentLocation({required double lat, required double lng}) async {
    await getMapCollection.doc('jamalshahzee').update({
      'Lat': lat,
      'Lng': lng,
    });
  }
}



