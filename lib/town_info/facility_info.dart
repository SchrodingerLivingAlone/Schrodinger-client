import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'category_dropdown.dart';

class FacilityInfoPage extends StatefulWidget {
  final int tabIndex;

  const FacilityInfoPage({super.key, required this.tabIndex});

  @override
  State<FacilityInfoPage> createState() => _FacilityInfoPageState();
}

class _FacilityInfoPageState extends State<FacilityInfoPage> {
  late List<TownInfo> facilityList = [];

  @override
  void initState() {
    super.initState();
    getFacilityPost();
  }

  List<Widget> createFacilityListTiles() {
    List<Widget> foodTiles = [];
    for (int i = 0; i < facilityList.length; i++) {
      TownInfo food = facilityList[i];

      Widget foodTile = Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          title: Text(food.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(food.content, style: TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(food.dong),
                  const SizedBox(width: 10),
                  Text(food.calculatedTime),
                  const SizedBox(width: 10),
                  Text('조회 ${food.view}'),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: [
              Image.network(
                food.imageUrl,
                width: 60,
                height: 40,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // 이미지 로드 완료됨
                  } else {
                    return const CircularProgressIndicator(); // 이미지 로드 중
                  }
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset('assets/default_profile.png', width: 60, height: 40,); // 오류 발생 시 기본 이미지
                },
              ),
              Text('댓글 ${food.commentCount} 공감 ${food.likeCount}', style: TextStyle(fontSize: 11)),
            ],
          ),
          onTap: () {},
        ),
      );
      foodTiles.add(foodTile);
    }
    return foodTiles;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CategoryDropdown(),
        ...createFacilityListTiles(),
      ],
    );
  }

  Future<void> getFacilityPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=0&category=${widget.tabIndex}';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<TownInfo> facilities = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      facilityList = facilities;
    });
  }
}