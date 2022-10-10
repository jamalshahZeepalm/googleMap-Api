import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mymap/app/modules/home/controllers/map_controller.dart';

class MapSample extends StatefulWidget {
  final double lat, lng;
  String address;
  MapSample(
      {super.key, required this.lat, required this.lng, required this.address});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  MapController mapController = Get.find<MapController>();
  final Completer<GoogleMapController> _controller = Completer();

  double _destLatitude = 0.0, _destLongitude = 0.0;
  Map<MarkerId, Marker> _marker = {};
  Map<PolylineId, Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyA1OxbF-Fh0ZSN7weXqt8pfaZMfKKEwLTc';
  CameraPosition? cameraPosition;
  @override
  void initState() {
    _destLatitude = widget.lat;

    _destLongitude = widget.lng;
    log("$_destLatitude this is init $_destLongitude");

    cameraPosition = CameraPosition(
      target: LatLng(
        _destLatitude,
        _destLongitude,
      ),
      zoom: 14,
    );
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      init: MapController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            body: GoogleMap(
              compassEnabled: true,
              initialCameraPosition: cameraPosition!,
              markers: Set<Marker>.of(_marker.values),
              polylines: Set<Polyline>.of(_polyline.values),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController con) {
                _controller.complete(con);
              },
            ),
          ),
        );
      },
    );
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      log('Error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  void loadData() {
    getCurrentLocation().then((value) async {
      getstore(lat: value.latitude, lng: value.longitude);
    });
  }

  getstore({required double lat, required double lng}) async {
    await mapController.storeCurrentLocation(lat: lat, lng: lng);
    Timer.periodic(Duration(seconds: 5), (_) {
      getCurrentLocation().then(
        (value) async {
          if (value.latitude != _destLatitude &&
              value.longitude != _destLongitude) {
            polylineCoordinates = [
              LatLng(_destLatitude, _destLongitude),
              LatLng(value.latitude, value.longitude),
            ];
            for (var i = 0; i < polylineCoordinates.length; i++) {
              _addMarker(polylineCoordinates[i], i.toString(),
                  BitmapDescriptor.defaultMarker);

              CameraPosition cP = CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14,
              );
              await mapController.updateCurrentLocation(
                  lat: value.latitude, lng: value.longitude);
              log("${value.latitude} update new location ${value.longitude}");
              GoogleMapController controllers = await _controller.future;
              controllers.animateCamera(CameraUpdate.newCameraPosition(cP));
              _getPolyline(
                  originLatitude: value.latitude,
                  originLongitude: value.longitude);
              setState(() {});
            }
          } else {
            Get.snackbar('Google Map', 'we have reached');
            AlertDialog(
              content: Text('we have reached'),
            );
          }
        },
      );
    });
  }

  _getPolyline({required originLatitude, required originLongitude}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originLatitude, originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
      wayPoints: [
        PolylineWayPoint(
          location: widget.address,
        ),
      ],
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    _polyline[id] = polyline;
    setState(() {});
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    _marker[markerId] = marker;
  }
}
