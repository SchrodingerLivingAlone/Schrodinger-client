import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schrodinger_client/style.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapSection extends StatefulWidget {
  const GoogleMapSection({super.key});

  @override
  State<GoogleMapSection> createState() => _GoogleMapSectionState();
}

class _GoogleMapSectionState extends State<GoogleMapSection> {
  final Completer<GoogleMapController> _controller = Completer();

  List<double> currentCoord = [];

  @override
  void initState(){
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 350,
          color: AppColor.lightGrey,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: currentCoord.isNotEmpty ? LatLng(currentCoord[0], currentCoord[1]) : const LatLng(37.50508097213444, 126.95493073306663),

                zoom: 18
            ), // 초기 카메라 위치
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.yellow,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(5)
                ),
                onPressed: () async {
                  _moveCurrentLocation();
                },
                child: const SizedBox(
                  width: 60,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place),
                      Text('현재위치', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                )
            )
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 18.0,
      ),
    ));

    setState(() {
      currentCoord = [latitude, longitude];
    });
  }

  void _moveCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentCoord[0], currentCoord[1]),
        zoom: 18.0,
      ),
    ));
  }
}
