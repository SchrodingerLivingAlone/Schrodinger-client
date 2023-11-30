import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostSearch extends StatefulWidget {
  const PostSearch({super.key});

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final _locationSearchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _searchPlaces() async {
    try {
      final String? apiKey = dotenv.env['GOOGLE_MAP_KEY'];
      final String query = _locationSearchController.text;
      final List<Map<String, dynamic>> results = await searchPlaces(query, apiKey);

      setState(() {
        _searchResults = results;
        _markers.clear();
        for (var result in results) {
          final Map<String, dynamic> location = result['geometry']['location'];
          final double lat = location['lat'];
          final double lng = location['lng'];
          final String name = result['name'];

          _markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name,
              ),
            ),
          );
        }
      });
    } catch (e) {
      print('Error searching places: $e');
    }
  }

  Widget _buildSearchResults() {
    if (_searchResults == null) {
      return Container();
    }

    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> result = _searchResults[index];
          return ListTile(
            title: Text(result['name']),
            subtitle: Text(result['formatted_address']),
            onTap: () {
              // 여기에서 선택된 장소를 지도에 표시하거나 다른 동작을 수행할 수 있습니다.
              // 이 예제에서는 선택된 장소의 좌표로 지도를 이동합니다.
              final Map<String, dynamic> location = result['geometry']['location'];
              final double lat = location['lat'];
              final double lng = location['lng'];
              mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.purple,
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          title:
              const Padding(
                padding: EdgeInsets.fromLTRB(95, 0, 0, 0),
                child: Text('장소 공유', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
        ),
        body: Column(
          children: [
            Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 10, 0),
                    child: SizedBox(
                      height: 30,
                      width: 300,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              labelText: '검색어를 입력하세요.',
                            ),
                            controller: _locationSearchController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|a-z|A-Z]')),
                          ],
                          ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                        _searchPlaces();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          minimumSize: const Size(40, 30),
                          primary: Colors.white,
                          elevation: 10),
                      child: Icon(Icons.search_rounded, color: Colors.deepPurple,))
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.5078, 126.9613), // 초기 위치
                  zoom: 12.0,
                ),
                markers: _markers,
              ),
            ),
             Expanded(
               child: ListView(
                 children: [
                   _buildSearchResults(),
                 ],
               ),
             ),

          ],
        )
    );
  }
}

Future<List<Map<String, dynamic>>> searchPlaces(String query, String? apiKey) async {
  final String apiUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
  final String requestUrl = '$apiUrl?query=$query&key=$apiKey';

  final response = await http.get(Uri.parse(requestUrl));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> results = data['results'];
    print(response.body);
    return results.map((result) => result as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load places');
  }
}
