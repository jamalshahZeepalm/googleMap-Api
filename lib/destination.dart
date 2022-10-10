import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:mymap/map_sample.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  late double longitude;
  late double latitude;
  String address = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Destination Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Enter your Destination latitude and longitude code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500,
                width: 300,
                child: FlutterLocationPicker(
                  initZoom: 11,
                  minZoomLevel: 5,
                  maxZoomLevel: 16,
                  trackMyPosition: true,
                  onPicked: (pickedData) {
                    latitude = pickedData.latLong.latitude;
                    longitude = pickedData.latLong.longitude;
                     address= pickedData.address;
                    Get.to(() => MapSample(lat: latitude, lng: longitude,address: address,));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
