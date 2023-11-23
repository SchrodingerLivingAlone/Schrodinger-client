import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:schrodinger_client/style.dart';


class GoogleMapSection extends StatefulWidget {
  const GoogleMapSection({super.key});

  @override
  State<GoogleMapSection> createState() => _GoogleMapSectionState();
}

class _GoogleMapSectionState extends State<GoogleMapSection> {
  final Completer<GoogleMapController> _controller = Completer();

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
            initialCameraPosition: const CameraPosition(
                target: LatLng(37.50508097213444, 126.95493073306663),
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
                onPressed: (){
                  _currentLocation();
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

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Location location = Location();
    final currentLocation = await location.getLocation();


    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 18.0,
      ),
    ));
  }
}
