import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostSearch extends StatefulWidget {

  PostSearch({super.key, required this.curLocation, required this.onStringReturned});
  final Function(String) onStringReturned;
  String curLocation;

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final _locationSearchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String searchedLocation = '찾을 장소를 검색해주세요.';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchPlaces(widget.curLocation);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }


  Future<void> _searchPlaces(String search) async {
    try {
      final String? apiKey = dotenv.env['GOOGLE_MAP_KEY'];
      final String query = search;
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
    return SizedBox(
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
              setState(() {
                searchedLocation = result['name'];
              });
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
          leading: IconButton(
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
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  if(searchedLocation != '찾을 장소를 검색해주세요.'){
                    widget.onStringReturned(searchedLocation);
                  }
                  Navigator.pop(context);
                },
                child: const Text('등록',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: HighLightedText(searchedLocation, fontSize: 20, color: Colors.deepPurple),
            ),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|a-z|A-Z|0-9]')),
                          ],
                          ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                        _searchPlaces(_locationSearchController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: Colors.white,
                          minimumSize: const Size(40, 30),
                          elevation: 10),
                      child: const Icon(Icons.search_rounded, color: Colors.deepPurple,))
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
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
  const String apiUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
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

class HighLightedText extends StatelessWidget {
  final String data;
  final Color color;
  final double fontSize;

  const HighLightedText(
      this.data, {
        super.key,
        required this.color,
        this.fontSize = 14,
      });

  Size getTextSize({
    required String text,
    required TextStyle style,
    required BuildContext context,
  }) {
    final Size size = (TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
    final Size textSize = getTextSize(
      text: data,
      style: textStyle,
      context: context,
    );
    return Stack(
      children: [
        Text(data, style: textStyle),
        Positioned(
          top: textSize.height / 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: color.withOpacity(0.2),
            ),
            height: textSize.height / 2,
            width: textSize.width,
          ),
        )
      ],
    );
  }
}