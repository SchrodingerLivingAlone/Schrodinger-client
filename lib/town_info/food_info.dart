import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/town_info/category_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FoodInfoPage extends StatefulWidget {
  final int tabIndex;

  const FoodInfoPage({super.key, required this.tabIndex});

  @override
  State<FoodInfoPage> createState() => _FoodInfoPageState();
}

class _FoodInfoPageState extends State<FoodInfoPage> {
  late List<TownInfo> foodList = [];

  @override
  void initState() {
    super.initState();
    getFoodPost();
  }

  List<Widget> createFoodListTiles() {
    List<Widget> foodTiles = [];

    for (int i = 0; i < foodList.length; i++) {
      TownInfo food = foodList[i];


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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostInfo(PostId: food.id)));
          },
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
        ...createFoodListTiles(),
      ]
    );
  }

  Future<void> getFoodPost() async {
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
    List<TownInfo> foods = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      foodList = foods;
    });
  }
}

class TownInfo {
  int id;
  String dong;
  String neighborhoodPostCategory;
  String title;
  String content;
  String imageUrl;
  String createdAt;
  String calculatedTime;
  int view;
  int likeCount;
  int commentCount;



  TownInfo({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.calculatedTime,
    required this.view,
    required this.likeCount,
    required this.commentCount,
  });

  factory TownInfo.fromJson(Map<String, dynamic> json) {
    return TownInfo(
      id: json['id'],
      dong: json['dong'],
      neighborhoodPostCategory: json['neighborhoodPostCategory'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      calculatedTime: json['calculatedTime'],
      view: json['view'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
    );
  }
}
