import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                onPressed: (){},
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

  // TODO: 현재 위치로 돌아오는 이벤트
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
