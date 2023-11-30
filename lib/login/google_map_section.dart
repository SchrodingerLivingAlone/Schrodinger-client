import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schrodinger_client/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapSection extends StatefulWidget {
  final Function(TownAddress)? updateTownName;
  final bool isMapLoaded;

  const GoogleMapSection({super.key, required this.isMapLoaded, required this.updateTownName});


  @override
  State<GoogleMapSection> createState() => _GoogleMapSectionState();
}

class _GoogleMapSectionState extends State<GoogleMapSection> {
  final Completer<GoogleMapController> _controller = Completer();

  List<double> currentCoord = [];
  String currentAddress = '';
  bool isMapLoaded = false;
  late Function(TownAddress) updateTownName;

  @override
  void initState(){
    super.initState();
    updateTownName = widget.updateTownName!;
    isMapLoaded = widget.isMapLoaded;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      isMapLoaded = true;
    });

    _getCurrentAddress();
  }

  Future<void> _getCurrentAddress() async {
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentCoord[0]},${currentCoord[1]}&language=ko&key=${dotenv.env['GOOGLE_MAP_KEY']}';

    final responseGps = await http.get(Uri.parse(gpsUrl));
    final responseJson = jsonDecode(responseGps.body);

    final address = responseJson['results'][0]['address_components'];
    String city = address[3]['short_name'];
    String gu = address[2]['short_name'];
    String dong = address[1]['short_name'];

    final townAddress = TownAddress(city: city, gu: gu, dong: dong);
    updateTownName(townAddress);
  }
}

class TownAddress {
  String city;
  String gu;
  String dong;

  TownAddress({required this.city, required this.gu, required this.dong});
}
